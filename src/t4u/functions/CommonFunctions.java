package t4u.functions;

import java.awt.Color;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.ProtocolException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LanguageWordsBean;
import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.beans.SubListBean;
import t4u.beans.Vehicle;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.common.DESEncryptionDecryption;
import t4u.statements.AdminStatements;
import t4u.statements.CommonStatements;
import t4u.statements.CreateTripStatement;
import t4u.statements.GeneralVerticalStatements;
import t4u.statements.MapViewStatements;

import com.google.gson.JsonObject;
import com.google.gson.internal.LinkedTreeMap;
import com.itextpdf.text.pdf.BarcodeQRCode;
import com.lowagie.text.BadElementException;
import com.lowagie.text.Element;
import com.lowagie.text.Image;
import com.lowagie.text.pdf.Barcode128;
import com.lowagie.text.pdf.PdfContentByte;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.GeometryFactory;
import com.vividsolutions.jts.geom.LinearRing;
import com.vividsolutions.jts.geom.Point;
import com.vividsolutions.jts.geom.Polygon;

/**
 * 
 * This class is used to write the common functions that are related to sql database
 *
 */

public class CommonFunctions
{
	HashMap langConverted=ApplicationListener.langConverted;
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	DecimalFormat df1 = new DecimalFormat("00");
    DecimalFormat df2 = new DecimalFormat("00.00");
    SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    public static Object lock = new Object();
	/**
	 * To fetch customer id and name from database
	 * @param SystemId
	 * @param ltsp
	 * @param customerIdlogin
	 * @return
	 */
	public JSONArray getCustomer(int SystemId,String ltsp,int customerIdlogin){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(customerIdlogin>0){
				pstmt=conAdmin.prepareStatement(CommonStatements.GET_CUSTOMER_FOR_LOGGED_IN_CUST);
				pstmt.setInt(1, SystemId);
				pstmt.setInt(2,customerIdlogin );
			}else{
				pstmt=conAdmin.prepareStatement(CommonStatements.GET_CUSTOMER);
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
	
	/**
	 * To check login Info bean is null or not and if null response is redirected to logout error page
	 * @param loginInfo
	 * @param session
	 * @param request
	 * @param response
	 */
	public void checkLoginInfo(LoginInfoBean loginInfo,HttpSession session,HttpServletRequest request, HttpServletResponse response){
		if(loginInfo==null){
			try {
				response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
			} catch (IOException e) {
				System.out.println("error in checkLoginInfo "+e.toString());
			}
		}
	}
	

	/**
	 * Fetches Language specific words
	 * @return
	 */
	public HashMap<String,LanguageWordsBean> LanguageConverter(){
		HashMap<String,LanguageWordsBean> langConverted=new HashMap<String,LanguageWordsBean>();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_LANGUAGE_VARIABLES);
			rs=pstmt.executeQuery();
			while(rs.next()){
				String label=rs.getString("LABEL_ID");
				String wordArabicConverted=rs.getString("LANG_ARABIC");
				String wordEnglishConverted=rs.getString("LANG_ENGLISH");
				LanguageWordsBean lwb=new LanguageWordsBean();
				lwb.setArabicWord(wordArabicConverted);
				lwb.setEnglishWord(wordEnglishConverted);
				langConverted.put(label, lwb);
			}
		}catch(Exception e){
			System.out.println("Error in LanguageConverter "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}	
		return langConverted;
	}
	
	
	/**
	 * To fetch menus based on feature clicked
	 * @param feature
	 * @return
	 */
	public ArrayList getMenuList(int feature){
		ArrayList menulist=new ArrayList();
		ArrayList list=new ArrayList();
		ArrayList sublist=new ArrayList();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_MENU_STRUTURE_FOR_FEATURE);
			pstmt.setInt(1, feature);
			rs=pstmt.executeQuery();
			String prevparentname="";
			while(rs.next()){
				String parentname=rs.getString("PARENT_REPORT_NAME");
				if(prevparentname.equals("") || !prevparentname.equals(parentname)){
					if(!prevparentname.equals("") && !prevparentname.equals(parentname)){
						menulist.add(list);
						list=new ArrayList();
					}
					list.add(parentname);
					list.add(rs.getString("PARENT_JSP_NAME"));
					list.add(feature);
					if(rs.getInt("CHILD_ID")>0){
						sublist=new ArrayList();
						sublist.add(rs.getString("CHILD_REPORT_NAME"));
						sublist.add(rs.getString("CHILD_JSP_NAME"));
						sublist.add(feature);
//						if(rs.getString("IS_CHILD_PARENT").equals("YES")){
							//getsubmenu
//						}
						list.add(sublist);
						sublist=new ArrayList();
					}
				}else if(prevparentname.equals(parentname)){
					sublist=new ArrayList();
					sublist.add(rs.getString("CHILD_REPORT_NAME"));
					sublist.add(rs.getString("CHILD_JSP_NAME"));
					sublist.add(feature);
//					if(rs.getString("IS_CHILD_PARENT").equals("YES")){
						//getsubmenu
//					}
					list.add(sublist);
					sublist=new ArrayList();
				}
				prevparentname=parentname;
			}
			if(list.size()>0){
				menulist.add(list);
				list=new ArrayList();
			}
		}catch(Exception e){
			System.out.println("Error in getMenuList "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}	
		return menulist;
	}
	
	/**
	 * Fetching features to be selected for customer from database
	 * @param CustomerId
	 * @return FeatureList
	 */
	public ArrayList getFeatureListForCustomer(String CustomerId){
		ArrayList featurelist=new ArrayList();
		ArrayList list=new ArrayList();
		ArrayList sublist=new ArrayList();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_FEATURE_LIST_FOR_CUSTOMER);
			pstmt.setString(1, CustomerId);
			rs=pstmt.executeQuery();
			String featureids="";
			if(rs.next()){
				featureids=rs.getString("FEATURE_LIST");
			}
			pstmt=null;
			rs=null;
			
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_FEATURE_LIST_FOR_GROUP.replace("#", featureids));
			rs=pstmt.executeQuery();
			String prevtype="";
			while(rs.next()){
				String type=rs.getString("TYPE");
				String featureid=rs.getString("ID");
				String feature=rs.getString("FEATURE_NAME");
				String RateTag=rs.getString("RATE_TAG");
				String Menustr=rs.getString("MENUSTR");
				if(prevtype.equals("") || !prevtype.equals(type)){
					if(!prevtype.equals("") &&  !prevtype.equals(type)){
						if(sublist.size()>0){
							list.add(sublist);
							sublist=new ArrayList();							
						}
						featurelist.add(list);
						list=new ArrayList();
					}
					list.add(type);
					sublist.add(featureid);
					sublist.add(feature);
					sublist.add(RateTag);
					sublist.add(Menustr);
				}else if(prevtype.equals(type)){
					sublist.add(featureid);
					sublist.add(feature);
					sublist.add(RateTag);
					sublist.add(Menustr);
				}
				prevtype=type;
			}
			if(sublist.size()>0){
				list.add(sublist);
				sublist=new ArrayList();
				featurelist.add(list);
				list=new ArrayList();
			}		
		}catch(Exception e){
			System.out.println("Error in getFeatureList "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return featurelist;
	}
	
	/**
	 * Fetching features to be selected from database
	 * @return FeatureList
	 */
	public ArrayList getFeatureList(int systemId){
		ArrayList featurelist=new ArrayList();
		ArrayList list=new ArrayList();
		ArrayList sublist=new ArrayList();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_FEATURE_LIST);
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			String prevtype="";
			while(rs.next()){
				String type=rs.getString("TYPE");
				String featureid=rs.getString("ID");
				String feature=rs.getString("FEATURE_NAME");
				String RateTag=rs.getString("RATE_TAG");
				String menustr=rs.getString("MENUSTR");
				if(prevtype.equals("") || !prevtype.equals(type)){
					if(!prevtype.equals("") &&  !prevtype.equals(type)){
						if(sublist.size()>0){
							list.add(sublist);
							sublist=new ArrayList();							
						}
						featurelist.add(list);
						list=new ArrayList();
					}
					list.add(type);
					sublist.add(featureid);
					sublist.add(feature);
					sublist.add(RateTag);
					sublist.add(menustr);
				}else if(prevtype.equals(type)){
					sublist.add(featureid);
					sublist.add(feature);
					sublist.add(RateTag);
					sublist.add(menustr);
				}
				prevtype=type;
			}
			if(sublist.size()>0){
				list.add(sublist);
				sublist=new ArrayList();
				featurelist.add(list);
				list=new ArrayList();
			}		
		}catch(Exception e){
			System.out.println("Error in getFeatureList "+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return featurelist;
	}
	
	public String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return formattedDate;
	}
	
	public String getFormattedDate(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd-MM-yyyy");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return formattedDate;
	}
	
	
	
	
	public String getFormattedDateddMMYYYY(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return formattedDate;
	}
	
	public String getLocalDateTime(String inputDate,int offSet) {
		String retValue=inputDate;
		Date convDate=null;
		convDate=convertStringToDate(inputDate);
		if (convDate!=null) {
			Calendar cal=Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE,-offSet);
			
			int day=cal.get(Calendar.DATE);
			int y=cal.get(Calendar.YEAR);
			int m=cal.get(Calendar.MONTH)+1;
			int h=cal.get(Calendar.HOUR_OF_DAY);
			int mi=cal.get(Calendar.MINUTE);
			int s=cal.get(Calendar.SECOND);
			
			String yyyy=String.valueOf(y);
			String month=String.valueOf(m>9?String.valueOf(m):"0"+String.valueOf(m));
			String date=String.valueOf(day>9?String.valueOf(day):"0"+String.valueOf(day));
			String hour=String.valueOf(h>9?String.valueOf(h):"0"+String.valueOf(h));
			String minute=String.valueOf(mi>9?String.valueOf(mi):"0"+String.valueOf(mi));
			String second=String.valueOf(s>9?String.valueOf(s):"0"+String.valueOf(s));
			
			retValue=month+"/"+date+"/"+yyyy+" "+hour+":"+minute+":"+second;
			
		}
		return retValue;
	}
	
	public   String getGMTDateTime(String inputDate,int offSet) {
		String retValue=inputDate;
		Date convDate=null;
		convDate=convertStringToDate(inputDate);
		if (convDate!=null) {
			Calendar cal=Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE,-offSet);
			
			int day=cal.get(Calendar.DATE);
			int y=cal.get(Calendar.YEAR);
			int m=cal.get(Calendar.MONTH)+1;
			int h=cal.get(Calendar.HOUR_OF_DAY);
			int mi=cal.get(Calendar.MINUTE);
			int s=cal.get(Calendar.SECOND);
			
			String yyyy=String.valueOf(y);
			String month=String.valueOf(m>9?String.valueOf(m):"0"+String.valueOf(m));
			String date=String.valueOf(day>9?String.valueOf(day):"0"+String.valueOf(day));
			String hour=String.valueOf(h>9?String.valueOf(h):"0"+String.valueOf(h));
			String minute=String.valueOf(mi>9?String.valueOf(mi):"0"+String.valueOf(mi));
			String second=String.valueOf(s>9?String.valueOf(s):"0"+String.valueOf(s));
			
			retValue=month+"/"+date+"/"+yyyy+" "+hour+":"+minute+":"+second;
			
		}
		return retValue;
	}

	public  Date convertStringToDate(String inputDate) {
	  	 Date dDateTime=null;
	  	 SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	  	 try {
	  		 if(inputDate!=null && !inputDate.equals("")) {
	  			dDateTime=sdfFormatDate.parse(inputDate);
	  			java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime.getTime()); 
	  			dDateTime=timest;
	  		 }
	  	 } catch(Exception e) {
	  		 System.out.println("Error in convertStringToDate method"+e);
	  		 e.printStackTrace();
	  	 }
	  	 return dDateTime;
	  }

	public String getCustomerName(String clientId, int systemId) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String customerName = null;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_CLIENT_NAME);
			pstmt.setString(2, clientId);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				customerName = rs.getString("NAME");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return customerName;
	}
	public String getLocationQuery(CharSequence query,String zone){
	  	String retValue=query.toString();
	  	retValue=query.toString().replaceAll("LOCATION_ZONE","LOCATION_ZONE"+"_"+zone);
	  	return retValue;
	  }
	/**
	 * This function will get the all the group names of particular customer and ltsp without all option.
	 * @param clientId
	 * @param systemId
	 * @param userId
	 * @return
	 */
	public JSONArray getgroupnames(int clientId, int systemId) 
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_GROUP_NAME_FOR_CLIENT);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
		
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("GroupId", rs.getString("GROUP_ID"));
				obj1.put("GroupName", rs.getString("GROUP_NAME"));
				jsonArray.put(obj1);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			jc.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	/**
	 * This function will replace every occurrence of string LOCATION_ZONE with the zone you are passing.
	 * eg:if you are passing zone as A then every occurence of LOCATION_ZONE in your string will be replaced as 
	 * LOCATION_ZONE_A.
	 * @param s
	 * @param zone
	 * @return
	 */
	public String replaceZone(String s,String zone)
	{
		return s.replaceAll("LOCATION_ZONE", "LOCATION_ZONE_"+zone);
	}
	/**
	 * This function will get the all the group names of particular customer and ltsp with all option.
	 * @param clientId
	 * @param systemId
	 * @param userId
	 * @return
	 */
	public JSONArray getgroupnamesAll(int clientId, int systemId) 
	{
		
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_GROUP_NAME_FOR_CLIENT);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			obj1 = new JSONObject();
			obj1.put("GroupId", "0");
			obj1.put("GroupName", "ALL");
			jsonArray.put(obj1);

			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("GroupId", rs.getString("GROUP_ID"));
				obj1.put("GroupName", rs.getString("GROUP_NAME"));
				jsonArray.put(obj1);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			jc.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	/**
	 * coverts minutes into HH:MM format
	 * @param minutes
	 * @return
	 */
	public String convertMinutesToHHMMFormat(int minutes) 
	{
		String duration="";
		
		long durationHrslong = minutes / 60;
		String durationHrs = String.valueOf(durationHrslong);
		if(durationHrs.length()==1)
		{
			durationHrs = "0"+ durationHrs;
		}
		
		long durationMinsLong = minutes % 60;
		String durationMins = String.valueOf(durationMinsLong);
		if(durationMins.length()==1)
		{
			durationMins = "0"+ durationMins;
		}
		
		duration = durationHrs + ":" + durationMins;
		
		return duration;
	}
	public String convertMinutesToHHMMFormatNegative(int minutes) 
	{
		String duration="";		
		minutes = -(minutes);
		long durationHrslong = minutes / 60;
		String durationHrs = (durationHrslong < 10 ? "0" : "")+ durationHrslong ;		
		long durationMinsLong = (minutes % 60);
		
		String durationMins = (durationMinsLong < 10 ? "0" : "")+ durationMinsLong ;	
		duration = durationHrs + ":" + durationMins;
		return "-"+duration;
	}
	/**
	 * coverts minutes into HH.MM format
	 * @param minutes
	 * @return
	 */
	public String convertMinutesToHHMMFormat1(int minutes) 
	{
		String duration="";
		
		long durationHrslong = minutes / 60;
		String durationHrs = String.valueOf(durationHrslong);
		if(durationHrs.length()==1)
		{
			durationHrs = "0"+ durationHrs;
		}
		
		long durationMinsLong = minutes % 60;
		String durationMins = String.valueOf(durationMinsLong);
		if(durationMins.length()==1)
		{
			durationMins = "0"+ durationMins;
		}
		
		duration = durationHrs + "." + durationMins;
		
		return duration;
	}
	
	
	/**
	 * coverts HH:MM into minutes
	 * @param HH:MM
	 * @return
	 */
	public double convertHHMMToMinutes(String hourminutes) 
	{
//		System.out.println("convertHHMMToMinutes()");
//		System.out.println("hoursminutes="+hourminutes);
		double duration=0.00;
		String hours=hourminutes.substring(0, hourminutes.indexOf("."));
		String minutes=hourminutes.substring(hourminutes.indexOf(".")+1);
//		System.out.println("hours="+hours+" minutes="+minutes);
		double hoursdouble = 0.00;
		if (!hours.equals("")) {
			hoursdouble=Double.parseDouble(hours)*60;
		}
		duration = hoursdouble+Double.parseDouble(minutes);
//		System.out.println("duration="+duration);
		return duration;
	}
	public int convertHHMMToMinutes1(String hourminutes) 
	{
		int duration=0;
		String hours=hourminutes.substring(0, hourminutes.indexOf(":"));
		String minutes=hourminutes.substring(hourminutes.indexOf(":")+1);
		int hoursdouble = 0;
		if (!hours.equals("")) {
			hoursdouble=Integer.parseInt(hours)*60;
		}
		duration = hoursdouble+Integer.parseInt(minutes);
		return duration;
	}
	
	public int convertDDHHMMToMinutes(String dayhourminutes) 
	{
		if(dayhourminutes.isEmpty()){
			return 0;
		}
		int duration=0;
		String[] arr = dayhourminutes.split(":");
		String day=arr[0];
		String hours=arr[1];
		String minutes=arr[2];
		int hoursdouble = 0;
		int daysdouble = 0;
		if (!hours.equals("")) {
			hoursdouble=Integer.parseInt(hours)*60;
		}
		if (!day.equals("")) {
			daysdouble=Integer.parseInt(day)*1440;
		}
		duration = daysdouble+hoursdouble+Integer.parseInt(minutes);
		return duration;
	}
	
	public String formattedDaysHoursMinutes(long fromDateMillisec) {
		String formateddaysHoursMinutes = "";
		try {
			long d = fromDateMillisec;

			long dSeconds = d / 1000;
			long dM = d / (60 * 1000);
			long dH = d / (60 * 60 * 1000);
			long dD = d / (24 * 60 * 60 * 1000);
			long hours = (d % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000);
			long minutes = ((d % (24 * 60 * 60 * 1000)) % (60 * 60 * 1000))	/ (60 * 1000);
			String min=String.valueOf(minutes);
			String hr=String.valueOf(hours);
			String dd=String.valueOf(dD);
			if(String.valueOf(minutes).length()==1){min = "0"+ minutes;}
			if(String.valueOf(hours).length()==1){hr = "0"+ hours;}
			if(String.valueOf(dD).length()==1){dd = "0"+ dD;}
	        formateddaysHoursMinutes = dd + ":" + hr + ":" + min;    

		} catch (Exception e) {
			e.printStackTrace();
		}
		return formateddaysHoursMinutes;
	}
	/**
	 * converts hours into HH.MM format.
	 * @param durationHrs
	 * @return
	 */
	public String getHHMMTimeFormat(double durationHrs) 
	{
		String durationHrsStr = "0.0";
		if (durationHrs > 0.0) 
		{
			int hrs = (int) durationHrs;
			int min = (int) ((durationHrs - hrs) * 60);

			if (min < 10) 
			{
				durationHrsStr = String.valueOf(hrs) + ".0"
						+ String.valueOf(min);
			} 
			else 
			{
				durationHrsStr = String.valueOf(hrs) + "."
						+ String.valueOf(min);
			}
		}
		return durationHrsStr;
	}
	/**
	 * to get the vehicles associated to perticular group.
	 */

	public ArrayList getVehicleListOfGroup(int clientId,int systemId,String groupId) 
	{
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList vehicleList = new ArrayList();
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
			
			String query = CommonStatements.GET_REGISTRATION_NO;
			
			if(groupId.equals("0"))
			{
				query=query+" GROUP_ID="+groupId;
			}
			
			query=query+"order by GROUP_ID";
			
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1,clientId);
			pstmt.setInt(2,systemId);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				vehicleList.add(rs.getString("REGISTRATION_NUMBER"));
			}
		}
		catch (Exception e) 
		{
			System.out.println("Exception in checkForExistingStopAlert" + e);
		}
		finally
		{
			jc.releaseConnectionToDB(con, pstmt, rs);
		}
		return vehicleList;
	}
	public String getLabelFromDB(String key,String language)
	{
		String SelectCustomer;
		LanguageWordsBean lwb=null;
		
		lwb=(LanguageWordsBean)langConverted.get(key);
		if(language.equals("ar"))
		{
			SelectCustomer=lwb.getArabicWord();
		}
		else
		{
			SelectCustomer=lwb.getEnglishWord();
		}
		return SelectCustomer;
	}
	
	public String getHistoryQuery(CharSequence query, int systemId) {
		String retValue = query.toString();
		retValue = query.toString().replaceAll("HISTORY_DATA",
				"HISTORY_DATA" + "_" + systemId);
		retValue = retValue.toString().replaceAll("GE_DATA",
				"GE_DATA" + "_" + systemId);
		return retValue;
	}
	
//	public String getGeQuery(CharSequence query, int systemId) {
//		String retValue = query.toString();
//		retValue = retValue.toString().replaceAll("ams_archieve.ge_data",
//				"ams_archieve.ge_data" + "_" + systemId);
//		return retValue;
//	}
	
	/**
	 * To getLive data of a Vehicle
	 */
	public Vehicle getLiveData(String Registration_No)
		{
			Vehicle vehicle=new Vehicle();
			
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Connection con=null;
			try{
			con=DBConnection.getConnectionToDB("AMS");
			
			pstmt=con.prepareStatement(CommonStatements.GET_LIVE_DATA);
			pstmt.setString(1, Registration_No);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				
				vehicle.setRegistration_no(Registration_No);
				
				vehicle.setLongitude(rs.getDouble("LONGITUDE"));
				
				vehicle.setLatitude(rs.getDouble("LATITUDE"));
				
				vehicle.setSpeed(rs.getDouble("SPEED"));
				
				vehicle.setLocation(rs.getString("LOCATION"));
				
				vehicle.setIgnition(rs.getInt("IGNITION"));
				
				if(rs.getString("UNIT_NO")!=null && !rs.getString("UNIT_NO").equals("") )
				{
				vehicle.setUnitid(rs.getString("UNIT_NO"));
				}
				else
				{
					vehicle.setUnitid("");
				}
				
				vehicle.setSystemId(rs.getInt("System_id"));
				
				vehicle.setClientId(rs.getInt("CLIENTID"));
				
				vehicle.setGMT(rs.getString("GMT"));
				
				vehicle.setGpsDateTime(rs.getString("GPS_DATETIME"));
				
				vehicle.setOffSet(rs.getString("OFFSET"));
				
				if(rs.getString("DRIVER_NAME")!=null && !rs.getString("DRIVER_NAME").equals("") )
				{
				vehicle.setDriverName(rs.getString("DRIVER_NAME"));
				}
				else
				{
					vehicle.setDriverName("");
				}
				
				vehicle.setOdometer(rs.getDouble("ODOMETER"));
				
				vehicle.setCategory(rs.getString("CATEGORY"));
				
				vehicle.setDuration(rs.getDouble("DURATION"));
				
				vehicle.setFuelPercentage(rs.getDouble("FUEL_LEVEL_PERCENTAGE"));
				
				vehicle.setDeltaDistance(rs.getDouble("DELTADISTANCE"));
				
				vehicle.setTemperature(rs.getDouble("ANALOG_INPUT_2"));
				
				vehicle.setIo3(rs.getString("IO3"));
				
				vehicle.setIo4(rs.getString("IO4"));
				
				vehicle.setIo5(rs.getString("IO5"));
				
				vehicle.setIo6(rs.getString("IO6"));
				
				vehicle.setDriverId(rs.getInt("DRIVER_ASSOC_ID"));
				
			  }
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			finally{
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return vehicle;
		}
	/** Returns the Time Diffrence in minutes
	 * @param startdate
	 * @param enddate
	 * @return
	 */
	public int getTimeDiffrence(Date startdate,Date enddate)
	{
	int diffMinutes=0;
	SimpleDateFormat sdfformat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	Date d1 = null;
	Date d2 = null;

	try {
		d1=(Date)sdfformat.parse(sdfformat.format(startdate));
		d2=(Date)sdfformat.parse(sdfformat.format(enddate));
		long diff = d2.getTime() - d1.getTime();
	    diffMinutes = (int) (diff / (60 * 1000));


	} catch (Exception e) {
		e.printStackTrace();
	}
	return diffMinutes;
	}
	
	/**
	 * get Language Specific Word For Keys
	 * @param keys
	 * @param language
	 * @return
	 */
	public ArrayList<String> getLanguageSpecificWordForKey(ArrayList<String> keys,String language)
	{
		
		ArrayList<String> words=new ArrayList<String>();
		LanguageWordsBean lwb=null;
		for(int i=0;i<keys.size();i++){
		lwb=(LanguageWordsBean)langConverted.get(keys.get(i));
		if(language.equals("ar"))
		{
			words.add(lwb.getArabicWord());
		}
		else
		{   
			words.add(lwb.getEnglishWord());
		}
		}
		
		return words;
	}
	
	/**
	 * This function will get the all the group names of particular customer and ltsp without all option.
	 * @param clientId
	 * @param systemId
	 * @return
	 */
	public JSONArray getGroup(int clientId, int systemId) 
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(CommonStatements.GET_GROUP);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
		
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("GroupId", rs.getString("GROUP_ID"));
				obj1.put("GroupName", rs.getString("GROUP_NAME"));
				obj1.put("ActivationStatus", rs.getString("ACTIVATION_STATUS"));
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
	
	/**
	 * This function will get the all the group names of particular customer and ltsp without all option.
	 * @param clientId
	 * @param systemId
	 * @return
	 */
	public JSONArray getGroupNamesIncludingAllOption(int clientId, int systemId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			obj1 = new JSONObject();
			obj1.put("GroupId", "ALL");
			obj1.put("GroupName", "ALL");
			jsonArray.put(obj1);

			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(CommonStatements.GET_GROUP);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("GroupId", rs.getString("GROUP_ID"));
				obj1.put("GroupName", rs.getString("GROUP_NAME"));
				jsonArray.put(obj1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	/**
	 * This function will get the all the group names of particular customer and ltsp without all option.
	 * @param clientId
	 * @param systemId
	 * @return
	 */
	public JSONArray getallGroup(int clientId, int systemId) 
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(CommonStatements.GET_ALL_GROUP);
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
		
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("GroupId", rs.getString("GROUP_ID"));
				obj1.put("GroupName", rs.getString("GROUP_NAME"));
				obj1.put("ActivationStatus", rs.getString("ACTIVATION_STATUS"));
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
	/**
	 * To fetch customer id and name from database
	 * @param SystemId
	 * @param ltsp
	 * @param customerIdlogin
	 * @return
	 */
	public JSONArray getallCustomer(int SystemId,String ltsp,int customerIdlogin){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			if(customerIdlogin>0){
				pstmt=conAdmin.prepareStatement(CommonStatements.GET_ALL_CUSTOMER_FOR_LOGGED_IN_CUST);
				pstmt.setInt(1, SystemId);
				pstmt.setInt(2,customerIdlogin );
			}else{
				pstmt=conAdmin.prepareStatement(CommonStatements.GET_ALL_CUSTOMER);
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
	
	public JSONArray getRegistrationNo(int custId, int ltspId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(CommonStatements.GET_REGISTRATION_NO);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, ltspId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("VehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out.println("Error in CommonFunctions:-getRegistrationNo "+ e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getRegistrationNoBasedOnUser(int custId, int ltspId, int userId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(CommonStatements.GET_REGISTRATION_NO_BASED_ON_USER);
			pstmt.setInt(1, custId);
			pstmt.setInt(2, ltspId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("VehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out.println("Error in CommonFunctions:-getRegistrationNoBasedOnUser "+ e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getDriverName(int custId, int ltspId) {
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(CommonStatements.GET_DRIVER_NAME);
			pstmt.setInt(1, ltspId);
			pstmt.setInt(2, custId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("DriverId", rs.getString("Driver_id"));
				jsonObject.put("DriverName", rs.getString("DriverName").toUpperCase());
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			System.out.println("Error in CommonFunctions:-getDriverName "+ e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return jsonArray;
	}
	
	
	public double initializedistanceConversionFactor(int SystemId,Connection con, String registrationNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distanceUnitName;
		double distanceConversionFactor;		
		distanceConversionFactor = 1.0;
		distanceUnitName = "kms";
		
		try {
			pstmt = con.prepareStatement(CommonStatements.GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE);
			pstmt.setInt(1, SystemId);
			pstmt.setString(2, registrationNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor = rs.getDouble("ConversionFactor");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return distanceConversionFactor;
	}
	
	public boolean isVehicleInsideHub(Coordinate vehicleCoordinate,
			Coordinate c, double radius) {

		boolean retBoo = false;
		try {

			GeometryFactory geomFac = new GeometryFactory();
			com.vividsolutions.jts.geom.Point pt = geomFac.createPoint(c);
			radius = radius * 0.0102;
			Geometry bufferedGeom = pt.buffer(radius);

			com.vividsolutions.jts.geom.Point vehiclePt = geomFac
					.createPoint(vehicleCoordinate);

			retBoo = vehiclePt.within(bufferedGeom);

			return retBoo;

		} catch (Exception e) {
			System.out.println("Error inside isVehicleInsideHub" + e);
		}
		return retBoo;
	}
	public  boolean isVehicleInsidePolygon(Coordinate vehCoord, Coordinate[] coords)
	{
		boolean boo=false;
		try
		{
		   GeometryFactory geomFac = new GeometryFactory();
		   
		   Point pt = geomFac.createPoint(vehCoord);
		   LinearRing ring = geomFac.createLinearRing(coords);
	       Polygon polygon = geomFac.createPolygon(ring, null);
	       boo = polygon.contains(pt);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return boo;
	}
	public double distanceCalculate(double lon1, double lat1, double lon2,
			double lat2) {
		/*
		 * double lat1, lat2, lon1, lon2; lat1 = this.getEnvelope().getMinY();
		 * lat2 = this.getEnvelope().getMaxY(); lon1 =
		 * this.getEnvelope().getMinX(); lon2 = this.getEnvelope().getMaxX();
		 */
		final double deg2Rad = Math.PI / 180;
		final double Mi2Km = 1.609;
		final int RM = 3956; // average radius of Earth in miles.
		double lat1dr, lat2dr, lon1dr, lon2dr, gca;
		double dlat, dlon, fDistance, fTemp;

		lat1dr = lat1 * deg2Rad;
		lat2dr = lat2 * deg2Rad;
		lon1dr = lon1 * deg2Rad;
		lon2dr = lon2 * deg2Rad;
		dlat = lat2dr - lat1dr;
		dlon = lon2dr - lon1dr;

		fTemp = Math.sin(dlat / 2)
				* Math.sin(dlat / 2)
				+ (Math.cos(lat1dr) * Math.cos(lat2dr) * Math.sin(dlon / 2) * Math
						.sin(dlon / 2));
		gca = 2 * Math.asin(Math.min(1, Math.sqrt(fTemp)));
		fDistance = RM * gca;
		fDistance = fDistance * Mi2Km; // miles to kilometers
		return fDistance; // distance returned in Kilometers
	}
	
	public String getDayHrMinFormat(Double strDays) {
		String ConvertDaysToDuration = "";
		try {
			double iDays, lHrMinSec, lMinSec;
			int lDays, lHours, lMinutes;
	
			if (strDays == 0) {
				iDays = 0;
			} else {
				iDays = strDays/24;
			}

			lDays = (int) iDays;
			lHrMinSec = (iDays - lDays) * 24;
			lHours = (int) lHrMinSec;
			lMinSec = (lHrMinSec - lHours) * 60;
			lMinutes = (int) lMinSec;

			String Days = lDays <= 9 ? "0" + lDays : String.valueOf(lDays);
			String Hours = lHours <= 9 ? "0" + lHours : String.valueOf(lHours);
			String Minutes = lMinutes <= 9 ? "0" + lMinutes : String.valueOf(lMinutes);

			ConvertDaysToDuration = Days + " : " + Hours + " : " + Minutes;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ConvertDaysToDuration;
	}
	
	
	public JSONArray systemHealthGetCount(int clientId, int systemId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int goodCount=0;
		int poorCount=0;
		int goodHealth=0;
		int batteryVoltage=0;
		JSONArray systemhealthJSONArray=new JSONArray();
		JSONObject systemhealthJSONObject;
		try {
			systemhealthJSONObject=new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_BATTERY_VOLTAGE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			while (rs.next()) {	
			    batteryVoltage=rs.getInt("BatteryVoltage");			    
			    if (batteryVoltage==12)
			    {
				  goodHealth=rs.getInt("MAIN_BATTERY_VOLTAGE");
					if(goodHealth >= 9)
							{
							goodCount++;
							}
						else
							{
							poorCount++;
							}
				}else if (batteryVoltage==24)
					{
					goodHealth=rs.getInt("MAIN_BATTERY_VOLTAGE");
						if(goodHealth >=20)
							{
							goodCount++;
							}
						else
							{
							poorCount++;
							}
					}
			}
		
			systemhealthJSONObject.put("goodcountIndex",goodCount);
			systemhealthJSONObject.put("poorcountIndex",poorCount);
			
			 systemhealthJSONArray.put(systemhealthJSONObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return systemhealthJSONArray;
	
	}
	
	public ArrayList<Object> systemHealthGetDetails(int clientId, int systemId,int offset,String chartStatus) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Date alertdate=new Date();;
		String location="";
		String BatteryVoltage="";
		String AssetNo="";
		String mainbatteryvoltage="";
		String status="";
		int count=0;
		String AssetModel="";
		String category="";
		String duration="0.00";
		JSONArray systemhealthdetailsJSONArray=new JSONArray();
		JSONObject systemhealthdetailsJSONObject;
		ArrayList<Object> SystemHelthFinalList = new ArrayList<Object>();
		ArrayList<String> SystemHelthHeadersList = new ArrayList<String>();
		ArrayList<ReportHelper> SystemHelthReportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();
		
		SystemHelthHeadersList.add("SLNO");
		SystemHelthHeadersList.add("Asset Number");
		SystemHelthHeadersList.add("Asset Model");
		SystemHelthHeadersList.add("Battery Voltage");
		SystemHelthHeadersList.add("Status");
		SystemHelthHeadersList.add("Stoppage Time(HH.MM)");
		SystemHelthHeadersList.add("Last Communication");
		SystemHelthHeadersList.add("Location");
		SystemHelthHeadersList.add("Main Battery Voltage");
		SystemHelthHeadersList.add("battery health status");
		
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_SYSTEM_HEALTH_DETAILS);		
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
		
			while (rs.next()) 
			{
				systemhealthdetailsJSONObject=new JSONObject();
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				count++;				
				AssetNo=rs.getString("ASSET_NO");
				alertdate=rs.getTimestamp("ALERT_DATE");
				location=rs.getString("LOCATION");
				BatteryVoltage=rs.getString("BATTERY_VOLTAGE")+"V";
				mainbatteryvoltage=rs.getString("MAIN_BATTERY_VOLTAGE");
				AssetModel=rs.getString("ASSET_MODEL");		
				category=rs.getString("CATEGORY");		
				duration=stoppageTime(rs.getString("StopIdle"));		
				if (rs.getInt("BATTERY_VOLTAGE")==12)
				{
				 	   if(rs.getInt("MAIN_BATTERY_VOLTAGE") >= 9)
							{
							status = "Good";
							}
						else
							{
							status = "Poor";
							}
				}else if (rs.getInt("BATTERY_VOLTAGE")==24)
					{
					   if(rs.getInt("MAIN_BATTERY_VOLTAGE") >=20)
							{
							status = "Good";
							}
						else
							{
							status = "Poor";
							}
					}
				if(chartStatus.equals(status))
				{
					if(rs.getInt("BATTERY_VOLTAGE")!=0){
				systemhealthdetailsJSONObject.put("slno", Integer.toString(count));
				systemhealthdetailsJSONObject.put("AssetNo", AssetNo);
				systemhealthdetailsJSONObject.put("AssetModel", AssetModel);
				systemhealthdetailsJSONObject.put("categoryDI", category);
				systemhealthdetailsJSONObject.put("durationDI", duration);
				systemhealthdetailsJSONObject.put("batteryvoltage",BatteryVoltage);
				systemhealthdetailsJSONObject.put("alertdate",sdfyyyymmddhhmmss.format(alertdate));
				systemhealthdetailsJSONObject.put("location",location);
				systemhealthdetailsJSONObject.put("MainBatteryVoltage", mainbatteryvoltage);
				systemhealthdetailsJSONObject.put("batteryhealthstatus", status);
				systemhealthdetailsJSONArray.put(systemhealthdetailsJSONObject);
				
				informationList.add(Integer.toString(count));
				informationList.add(AssetNo);
				informationList.add(AssetModel);
				informationList.add(BatteryVoltage);
				informationList.add(category);
				informationList.add(duration);
				informationList.add(sdfyyyymmddhhmmss.format(alertdate));
				informationList.add(location);
				informationList.add(mainbatteryvoltage);
				informationList.add(status);
				reporthelper.setInformationList(informationList);
				SystemHelthReportsList.add(reporthelper);		
				
				}
				}	
				}
			SystemHelthFinalList.add(systemhealthdetailsJSONArray);
			finalreporthelper.setReportsList(SystemHelthReportsList);
			finalreporthelper.setHeadersList(SystemHelthHeadersList);
			SystemHelthFinalList.add(finalreporthelper);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}


		return SystemHelthFinalList;
	}
	
	public double getHrsFromDaysHrsMins(String daysHrsMins) {
		double hrs = 0.0;
		if (!daysHrsMins.equals("N/A")) {
			
			StringTokenizer st = new StringTokenizer(daysHrsMins, " ");
			String str[] = new String[3];
			int k = 0;
			
			while (st.hasMoreTokens()) {
				str[k] = (String) st.nextElement();
				k++;
			}
			int day = Integer.parseInt(str[0].replace("days", "").trim());
			int hour = Integer.parseInt(str[1].replace("hrs", "").trim());
			int min = Integer.parseInt(str[2].replace("mins", "").trim());

			hrs = (day * 24) + hour + (min / 60.0);
		}
		return hrs;
	}
	
	public  boolean checkAuthenticationMLLECommerce(String userName,String password,String vehicleNo){
		boolean isAuthorised=false;
		int systemId=0;
		String vehicleArray[]=vehicleNo.split(",");
		vehicleNo=""; 
		for (int i = 0; i < vehicleArray.length; i++) {
		vehicleNo=vehicleNo+"'"+vehicleArray[i]+"',";
		}
		vehicleNo=vehicleNo.substring(0,vehicleNo.length()-1);
		if ((userName.equals("t4umll") && password.equals("eCom2014"))||(userName.equals("T4uMap") && password.equals("M@pView$2014")))
		{
			isAuthorised = true;
		}
		else {
		DESEncryptionDecryption DES = new DESEncryptionDecryption();
		password = DES.encrypt(password);
		Connection connection=null;
	    PreparedStatement pstmt=null;
	    ResultSet resultSet=null;
	     try
	    {
	    	userName.replace("%20", " ");
	    	connection = DBConnection.getConnectionToDB("AMS");	
	    	pstmt=connection.prepareStatement(CommonStatements.GET_USERS);
	    	pstmt.setString(1, userName);
	    	pstmt.setString(2, password);
	    	resultSet=pstmt.executeQuery();
	    	if(resultSet.next())
	    	{
	    	systemId=resultSet.getInt("SYSTEM_ID");
	    	}
	    pstmt.close();
	    resultSet.close();
	    
	    if(systemId!=0)
	    {
	        pstmt=connection.prepareStatement(CommonStatements.GET_VEHICLE.replace("#", vehicleNo));
		    pstmt.setInt(1, systemId);
		    resultSet=pstmt.executeQuery();
		    if(resultSet.next())
		    {isAuthorised = true;
		    }
		    else return false;
		 }
	    }
	    catch (Exception e) {
			e.printStackTrace();// TODO: handle exception
		}
	    finally
	    {
	    	DBConnection.releaseConnectionToDB(connection, pstmt, resultSet);	
	    }
		}
		return isAuthorised;
	}
	
	public int getProcessID(int systemId, int clientId)
	{
	    Connection connection=null;
	    PreparedStatement pstmt=null;
	    ResultSet resultSet=null;
	    int processID=0;
	    try
	    {
	    	connection = DBConnection.getConnectionToDB("AMS");	
	    	pstmt=connection.prepareStatement(MapViewStatements.GET_PROCESS_ID);
	    	pstmt.setInt(1, systemId);
	    	pstmt.setInt(2, clientId);
	    	resultSet=pstmt.executeQuery();
	    	if (resultSet.next()) {
				processID=resultSet.getInt("PROCESS_ID");
			}
	    	
	    	if(processID == 0){
	    		processID=20;
	    	}
	    }
	    catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(connection, pstmt, resultSet);		
		}
		return processID;
	}
	
	public int checkProcessIdExistsForMapView(int processId)
	{
		Connection connection=null;
	    PreparedStatement pstmt=null;
	    ResultSet resultSet=null;
	    int processID=0;
	    try
	    {
	    	connection = DBConnection.getConnectionToDB("AMS");	
	    	pstmt=connection.prepareStatement(MapViewStatements.MAP_VIEW_HEADERS);
	    	pstmt.setInt(1, processId);	    
	    	resultSet=pstmt.executeQuery();
	    	if (resultSet.next()) {
				processID=resultSet.getInt("PROCESS_ID");
			}else
			{
				processID=20;
			}
	    	
	    	
	    }
	    catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(connection, pstmt, resultSet);		
		}
	return processID;
	}
	
	public String setNextDateForReports() {
		java.util.Date startdate = null;
		String strdate = "";
		startdate = new Date(System.currentTimeMillis() + 24 * 60 * 60 * 1000);
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		strdate = formatter.format(startdate);
		return strdate;
	}
	
	public   String AddOffsetToGmt(String inputDate,int offSet){
		String retValue=inputDate;
		Date convDate=null;
		convDate=convertStringToDate(inputDate);
		if(convDate!=null){
			Calendar cal=Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE,+offSet);
			
			
			int day=cal.get(Calendar.DATE);
			int y=cal.get(Calendar.YEAR);
			int m=cal.get(Calendar.MONTH)+1;
			int h=cal.get(Calendar.HOUR_OF_DAY);
			int mi=cal.get(Calendar.MINUTE);
			int s=cal.get(Calendar.SECOND);

			String yyyy=String.valueOf(y);
			String month=String.valueOf(m>9?String.valueOf(m):"0"+String.valueOf(m));
			String date=String.valueOf(day>9?String.valueOf(day):"0"+String.valueOf(day));
			String hour=String.valueOf(h>9?String.valueOf(h):"0"+String.valueOf(h));
			String minute=String.valueOf(mi>9?String.valueOf(mi):"0"+String.valueOf(mi));
			String second=String.valueOf(s>9?String.valueOf(s):"0"+String.valueOf(s));

			retValue=month+"/"+date+"/"+yyyy+" "+hour+":"+minute+":"+second;
			//System.out.println("New Date:::"+retValue);
			
		}
		return retValue;
	}	
	public String getCurrentTime(){
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet resultSet = null;
		String date="";
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			pstmt = connection.prepareStatement("SELECT CONVERT(VARCHAR(8),getUTCDATE(),108) AS HourMinuteSecond");
			resultSet = pstmt.executeQuery();
			while (resultSet.next()) {
				date=resultSet.getString("HourMinuteSecond");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, resultSet);
		}
		return date;
	}
//----------------------------------------added by santhosh-------------------------------//	
	public String getCurrency(int systemId)
	{
		String currency="Unit Not Set";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try
		{
			con= DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(CommonStatements.GET_CURRENCY);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
					currency= rs.getString("CURRENCY_SYMBOL");
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		return currency;
	}
	
	//---------------------------
	public ArrayList getLocationLatLong(String vehicleNo)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList arrayList=new ArrayList();
		try
		{
			con= DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(CommonStatements.GET_LOC_LAT_LONG);
			pstmt.setString(1, vehicleNo);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				arrayList.add(rs.getString("LONGITUDE"));
				arrayList.add(rs.getString("LATITUDE"));
				arrayList.add(rs.getString("LOCATION"));
				arrayList.add(sdfyyyymmddhhmmss.format(rs.getTimestamp("GPS_DATETIME")));
				
				
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con,pstmt,rs);
		}
		
		return arrayList;
	}
	//--------------------------------------Added By santhosh for fetching State Details-----------------------------//
	public JSONArray getStateList(int CountryCode) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = conAdmin.prepareStatement(CommonStatements.GET_STATE_LIST_FROM_ADMINSTRATOR);
			pstmt.setInt(1, CountryCode);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("StateID", rs.getString("StateId"));
				jsonObject.put("stateName", rs.getString("StateName"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	//--------------------------------------Added By santhosh for fetching for userAuthority Details-----------------------------//
	
	 public String getUserAuthority(int systemId,int userId)
     {
    	 Connection con = null;
		 PreparedStatement pstmt = null;
    	 ResultSet rs = null;
    	 String authority=null;

		 try {
		        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		        pstmt = con.prepareStatement(CommonStatements.GET_USER_AUTHORITY);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, userId);
		        rs = pstmt.executeQuery();
	    		if(rs.next())
	    		{
	    			authority=rs.getString("USERAUTHORITY");
	    		}


		 }
		 catch (Exception e) {
		        e.printStackTrace();
		 }
		 finally {
		    	
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		 return authority;
     }
	 
	 public String getVehicleList(int userId,int systemId,int isLtsp,int customerId){
		 Connection con = null;
		 PreparedStatement pstmt = null;
    	 ResultSet rs = null;
    	 String vehicleList=null;
    	 int count=0;    	
    	 try{
    		 con = DBConnection.getConnectionToDB("AMS");
    		 
    		 if(isLtsp==0){
    			 pstmt=con.prepareStatement(CommonStatements.GET_VEHICLE_LIST_FOR_LTSP);
    		 }else{
    			 pstmt=con.prepareStatement(CommonStatements.GET_VEHICLE_LIST_FOR_CUSTOMER);
    		 }
    		  	pstmt.setInt(1, customerId);
		        pstmt.setInt(2, systemId);
		        pstmt.setInt(3, userId);
		        rs = pstmt.executeQuery();
		        while(rs.next()){
		        	if(count==0){
		        		vehicleList=rs.getString("REGISTRATION_NO");
		        		count=1;
		        	}else{
		        		vehicleList=vehicleList+","+rs.getString("REGISTRATION_NO");
		        	}
		        	
		        }		      
    	 }catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
    	 
		 return vehicleList;
	 }
	 
	 public String getVehicleDetails(String vehicleNo,int systemId,int customerId){
		 Connection con = null;
		 PreparedStatement pstmt = null;
    	 ResultSet rs = null;
    	 String vehicleDetails=null;
    	 Date date = new Date();
    	 SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	 try{
    		 con = DBConnection.getConnectionToDB("AMS");
    		 pstmt=con.prepareStatement(CommonStatements.GET_VEHICLE_DETAILS);
    		 pstmt.setInt(1, systemId);
		     pstmt.setInt(2, customerId);
		     pstmt.setString(3,vehicleNo);
		     rs = pstmt.executeQuery();
    		 if(rs.next()){
    			 date = rs.getTimestamp("GPS_DATETIME");
    			 vehicleDetails=rs.getString("REGISTRATION_NO")+"!"+sdfyyyymmddhhmmss.format(date)+"!"
    			 +rs.getString("DRIVER_NAME")+"!"+rs.getString("DRIVER_MOBILE")+"!"+rs.getString("OWNER_NAME")+"!"+rs.getString("LOCATION")+"!"+rs.getString("Loading_Capacity");
    		 }
    		 	      
    	 }catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		 return vehicleDetails;
	 }
	
	//-------------------------------Common function for Generate barcode by santhosh---------------------------// 
	 public Image getBarCode(float x,float y,Boolean checksum,Boolean GenerateChecksum ,float size,float Baseline,String myText,float height,PdfContentByte canvas) {
		 Barcode128 code128 = new Barcode128();
					code128.setX(x);
					code128.setN(y);
					code128.setChecksumText(checksum);
					code128.setGenerateChecksum(GenerateChecksum);
					code128.setSize(size);
					code128.setTextAlignment(Element.ALIGN_CENTER);
					code128.setBaseline(Baseline);
					String data = myText;
			        code128.setCode(data.trim());
					code128.setBarHeight(height);
					Image code128Image = code128.createImageWithBarcode(canvas, Color.black, Color.black);
		    return code128Image;
		}
	//-------------------------------Common function for Generate QRcode by santhosh---------------------------// 	 
	public Image getQrCode(String text,int width,int height){
		Image finalQRImage = null;
		try {
			BarcodeQRCode qrcode = new BarcodeQRCode(text.trim(), 50, 50, null);
			java.awt.Image qr_awt_image = qrcode.createAwtImage(Color.BLACK,Color.WHITE);
			//java.awt.Image  qrImage = qrcode.createAwtImage(Color.WHITE,new Color(0, 0, 0, 0));
			finalQRImage = Image.getInstance(qr_awt_image, null);
		} catch (BadElementException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return finalQRImage;
		
	}
	public boolean isDateAfterDate(Date d1, Date d2) {
		int ff = 0;
		boolean addRequired = false;
		try {
			ff = d1.compareTo(d2);
			if (ff == 0) {
				addRequired = true;
			} else if (ff < 0) {
				addRequired = true;
			} else if (ff > 0) {
				addRequired = false;
			}
		} catch (Exception e) {

		}
		return addRequired;
	}
	public JSONArray getLiveVisionDetails(String vehicleNo) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String ignition=null;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_LIVEVISION_DETAILS);
			pstmt.setString(1,vehicleNo.toUpperCase());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JsonObject = new JSONObject();
				JsonObject.put("regNo",rs.getString("REGISTRATION_NO"));
				JsonObject.put("unitNo",rs.getString("UNIT_NO"));
				JsonObject.put("longitude",rs.getString("LONGITUDE"));
				JsonObject.put("latitude",rs.getString("LATITUDE"));
				JsonObject.put("location",rs.getString("LOCATION"));
				JsonObject.put("gpsDateTime",ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
				JsonObject.put("speed",rs.getString("SPEED"));
				ignition=rs.getString("IGNITION");
	        	 if(ignition.equals("0")){
	        		 ignition="OFF";
	        	 }
	        	 else{
	        		 ignition="ON";
	        	 }
				JsonObject.put("ignition",ignition);
				JsonObject.put("category",rs.getString("CATEGORY"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	  return JsonArray;	
	  }
	public String setNextDateForReportsNew() { //returns next day with month/day/year format
		java.util.Date startdate = null;
		String strdate = "";
		startdate = new Date(System.currentTimeMillis() + 24 * 60 * 60 * 1000);
		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
		strdate = formatter.format(startdate);
		return strdate;
	}
	public JSONArray getCountry() {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=con.prepareStatement(CommonStatements.GET_COUNTRY_LIST);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("countryIndex", rs.getString("COUNTRY_NAME"));
				jsonArray.put(jsonObject);
			}
			
		} catch (Exception e) {
			System.out.println("Error"+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	 public String getHubs(int systemId,int userId,int custId)
     {
    	 Connection con = null;
		 PreparedStatement pstmt = null;
    	 ResultSet rs = null;
    	 String hubId="";
    	 String hubId1="0";

		 try {
		        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
		        pstmt = con.prepareStatement(CommonStatements.GET_HUB_ID);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, userId);
		        rs = pstmt.executeQuery();
	    		while(rs.next())
	    		{
	    			hubId = hubId + rs.getString("HUBID") + ",";
	    			hubId1=hubId.substring(0, hubId.length() - 1);
	    		}


		 }
		 catch (Exception e) {
		        e.printStackTrace();
		 }
		 finally {
		    	
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    }
		 return hubId1;
     }
	 
	 public boolean isPaymentDue(int SystemId,int customerId) {
			 Connection con = null;
			 PreparedStatement pstmt = null;
	    	 ResultSet rs = null,rs1=null;
	    	 boolean due_Ids=false;
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select System_id from System_Master where Payment_Notifications='Y' and System_id=?");
				pstmt.setInt(1, SystemId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					due_Ids=true;
				}
				if(!due_Ids){
					pstmt = con.prepareStatement("select CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and PAYMENT_DUE_NOTIFICATION='Y' ");
					pstmt.setInt(1, SystemId);
					pstmt.setInt(2, customerId);
					rs1 = pstmt.executeQuery();
					if(rs1.next()){
						due_Ids=true;	
					}
				}
			} catch (Exception e) {
				System.out.println("Error getting System Payment Due Status : " + e);
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
				DBConnection.releaseConnectionToDB(null, null, rs1);
			}
			return due_Ids;
		}
	 public String getSystemZoneAndCategoryType(String systemId) {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Connection con = null;
			String zoneAndCategory = "";
			try {			
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(CommonStatements.GET_ZONE_CATEGORY_TYPE);
				pstmt.setString(1, systemId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					if (rs.getString("Zone") != null && !rs.getString("Zone").equals("")){
						zoneAndCategory = rs.getString("Zone");
						zoneAndCategory=zoneAndCategory+","+rs.getString("CategoryTypeForBill");
					}
				}
			} catch (Exception e) {
				System.out.println("Error in getSystemZoneAndCategoryType()." + e);
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return zoneAndCategory;
		}
	 public String getCountryName(int countryId) {
			Connection con=null;
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			String countryName="";
			try {
				con=DBConnection.getConnectionToDB("ADMINISTRATOR");
				pstmt=con.prepareStatement(CommonStatements.GET_COUNTRY_NAME_BASED_ON_ID);
				pstmt.setInt(1, countryId);
				rs=pstmt.executeQuery();
				while(rs.next()){
					countryName = rs.getString("COUNTRY_NAME");
				}
				
			} catch (Exception e) {
				System.out.println("Error"+e.toString());
			}finally{
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return countryName;
		}
	public String stoppageTime(String stop){
		
		double stopValue=0.0;
		if(stop!=null)
		{
		String vehDetails[] = new String[2];

		String arr[]=stop.split("@");

		if(arr.length>0)
		{
		vehDetails[0] = arr[0];
		vehDetails[1]=arr[1];
		}

		if("stoppage".equals(vehDetails[0])){
		double d = Double.parseDouble(vehDetails[1]);

		int hrs = (int)d;
		int min = (int)((d - hrs) * 60);
		String idletime="0.0";
		if(min < 10){
		idletime=String.valueOf(hrs)+".0"+String.valueOf(min);
		}else{
		idletime=String.valueOf(hrs)+"."+String.valueOf(min);
		}
		if (idletime!=null) {
		stopValue=Double.parseDouble(idletime);
		} else {
		stopValue=0.00;
		}
		}else{
			stopValue=0.00;
		}

		}
		return String.valueOf(stopValue);
		}
	/**
	 * To fetch LTSPS
	 * @param 
	 * @return
	 */
	public JSONArray getLTSPS(){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(CommonStatements.GET_LTSPS);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("ltspId", rs.getInt("System_id"));
				jsonObject.put("ltspName", rs.getString("System_Name"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getLTSPS "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}
	/**
	 * To fetch customer id and name from database based on selected LTSP System_id
	 * @param systemId
	 * @return
	 */
	public JSONArray getCustomersForLTSP(int systemId){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_CUSTOMER);
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("CustId", rs.getInt("CUSTOMER_ID"));
				jsonObject.put("CustName", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getCustomersForLTSP "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}	
		return jsonArray;
	}
	public JSONArray getTalukNamesForLTSP(int systemId,int clientid){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_TALUKNAMES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientid);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("TalukName", rs.getString("NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getTalukNamesForLTSP "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}	
		return jsonArray;
	}
	public JSONArray getMDPLimit(int systemId,int clientid,String taluk){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement(CommonStatements.GET_MDPLIMIT);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientid);
			pstmt.setString(3, taluk);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("MDPLimit", rs.getString("MDPLimit"));
				jsonArray.put(jsonObject);
			}
		}catch(Exception e){
			System.out.println("Error in getMDPLimit "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}	
		return jsonArray;
	}
	public int getVehicleCount(int clientId,int systemId,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int totalCount=0;
		try {
			con = DBConnection.getDashboardConnection("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_VEHICLE_LIST_FOR_CUSTOMER);
			pstmt.setInt(1, clientId);	
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);	
			rs = pstmt.executeQuery();
			while(rs.next()) {
				totalCount++;
				String vehicleNo = rs.getString("REGISTRATION_NO");
			}			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return totalCount;
	}
	public JSONArray getClientNames(int systemid, int clientid) 
	{
		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String stmt = "";
		try 
		{
			con = DBConnection.getDashboardConnection("AMS");			
			stmt = CommonStatements.GET_CLIENT_NAMES_TWHADR ;
			if (clientid > 0) 
			{
				stmt = stmt + " and CUSTOMER_ID=" + clientid;
			}
			stmt = stmt + " order by CustomerName";
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, systemid);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("clientId", rs.getString("CustomerId"));
				obj1.put("clientName", rs.getString("CustomerName"));
				jsonArray.put(obj1);
			}

		} 
		catch (Exception e) 
		{
			System.out.println("Error While Getting Client Names.");

			e.printStackTrace();
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getVehiclesBasedOnGroup(String systemid, String clientid,
			int userId, String groupid) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String stmt = "";
		String Vehno = "";

		try {
			con = DBConnection.getDashboardConnection("AMS");
			if (groupid != null && !groupid.equals("") && !groupid.equals("0")) {
				stmt = "select REGISTRATION_NUMBER from VEHICLE_CLIENT a, Vehicle_User b where a.SYSTEM_ID=? and a.CLIENT_ID=? and b.User_id=? and a.GROUP_ID=? and a.SYSTEM_ID = b.System_id and a.REGISTRATION_NUMBER = b.Registration_no order by REGISTRATION_NUMBER";
			} else {
				stmt = "select REGISTRATION_NUMBER from VEHICLE_CLIENT a, Vehicle_User b where a.SYSTEM_ID=? and a.CLIENT_ID=? and b.User_id=? and a.SYSTEM_ID = b.System_id and a.REGISTRATION_NUMBER = b.Registration_no order by REGISTRATION_NUMBER";
			}
			pstmt = con.prepareStatement(stmt);
			pstmt.setString(1, systemid);
			pstmt.setString(2, clientid);
			pstmt.setInt(3, userId);
			if (groupid != null && !groupid.equals("") && !groupid.equals("0")) {
				pstmt.setString(4, groupid);
			}

			rs = pstmt.executeQuery();
			

			while (rs.next()) {
				obj1 = new JSONObject();	
				obj1.put("vehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(obj1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getgroupnamesForAlert(int systemid, int clientid,int userId)
	{
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getDashboardConnection("AMS");	
			String stmt = "";
			stmt = CommonStatements.GET_GROUP_NAME_FOR_CLIENT_TWHADR ;
			pstmt = con.prepareStatement(stmt);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, clientid);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("groupId", rs.getString("GROUP_ID"));
				obj1.put("groupName", rs.getString("GROUP_NAME"));
				jsonArray.put(obj1);
			}
			obj1 = new JSONObject();
			obj1.put("groupId", "0");
			obj1.put("groupName", "ALL");
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
	
	public  HashMap<String, ArrayList<Object>> getHubArrivalAndDepartureDetails(int systemId,int month,int year,String regNo,int clientId,int offset,String locationzone){
	
	HashMap<String, ArrayList<Object>> tripDetailsObj = new HashMap<String, ArrayList<Object>>();
	ArrayList<Object> finalList= new ArrayList<Object>();
	HashMap<String, ArrayList<SubListBean>> innerhashmap = new HashMap<String,ArrayList<SubListBean>>();
	ArrayList<String> summaryList = new ArrayList<String>();
	SubListBean subListBean = new SubListBean();
	ArrayList<SubListBean> subList = new ArrayList<SubListBean>();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String currentDate ="";
	String prevDate ="";
	int tripCount=0;
	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
	
	
	try 
	{
		Calendar c1 = Calendar.getInstance();
		c1.set(Calendar.YEAR, year);
		c1.set(Calendar.MONTH, month);
		c1.set(Calendar.DAY_OF_MONTH, 1);
		
		Calendar c2 = Calendar.getInstance();
		c2.set(Calendar.YEAR, year);
		c2.set(Calendar.MONTH, month);
		c2.set(Calendar.DAY_OF_MONTH, c2.getActualMaximum(Calendar.DAY_OF_MONTH));
		
		String startTime = sdf.format(c1.getTime());
		String endTime = sdf.format(c2.getTime());
		con = DBConnection.getDashboardConnection("AMS");	
		String stmt = "";
		stmt = CommonStatements.TRIPWISE_HUB_ARRIVAL_DEPARTURE_DETAILS.replace("#", locationzone) ;
		pstmt = con.prepareStatement(stmt);
		pstmt.setInt(1, offset);
		pstmt.setInt(2, offset);
		pstmt.setInt(3, offset);
		pstmt.setInt(4, offset);
		pstmt.setInt(5, offset);
		pstmt.setString(6, startTime);
		pstmt.setString(7, endTime);
		pstmt.setString(8, regNo);
		pstmt.setInt(9, systemId);
		pstmt.setInt(10, offset);
		pstmt.setInt(11, offset);
		pstmt.setInt(12, offset);
		pstmt.setInt(13, offset);
		pstmt.setInt(14, offset);
		pstmt.setString(15, startTime);
		pstmt.setString(16, endTime);
		pstmt.setString(17, regNo);
		pstmt.setInt(18, systemId);
		rs = pstmt.executeQuery();
		
		innerhashmap = new HashMap<String,ArrayList<SubListBean>>();
		summaryList = new ArrayList<String>();

		subListBean = new SubListBean();

		while (rs.next()) 
		{			
		currentDate = rs.getString("KEY_DATE");
		summaryList = new ArrayList<String>();
		
		
		if(rs.getRow() == 1){
		finalList.add(tripCount);
		prevDate = rs.getString("KEY_DATE");
		regNo = rs.getString("REGISTRATION NO");
		summaryList.add(regNo);
		summaryList.add(rs.getString("Vehicle_Type"));
		summaryList.add(rs.getString("MODEL_NAME"));
		//summaryList.add(rs.getString("ODOMETER"));
		if(Float.parseFloat(rs.getString("ODOMETER"))==0){
			summaryList.add(rs.getString("ODOMETER_TVM"));
		}else{
			summaryList.add(rs.getString("ODOMETER"));
		}
		finalList.add(summaryList);
		
		subListBean = new SubListBean();
		subListBean.setInTime(rs.getString("ACTUAL ARRIVAL"));
		subListBean.setOutTime(rs.getString("ACTUAL DEPARTURE"));	
		subListBean.setBranchName(rs.getString("HUB_NAME"));
		subListBean.setDuration(rs.getDouble("DURATION"));
		subList.add(subListBean);
		}
		else{
			
			if(currentDate.equals(prevDate)){
				subListBean = new SubListBean();
				subListBean.setInTime(rs.getString("ACTUAL ARRIVAL"));
				subListBean.setOutTime(rs.getString("ACTUAL DEPARTURE"));	
				subListBean.setBranchName(rs.getString("HUB_NAME"));
				subListBean.setDuration(rs.getDouble("DURATION"));
				subList.add(subListBean);
			}else{
				
				innerhashmap.put(prevDate, subList);		

				tripDetailsObj.put(regNo,finalList);
                if(tripCount<subList.size()){
				tripCount = subList.size();
                }
				subList = new ArrayList<SubListBean>();
				summaryList = new ArrayList<String>();
				subListBean = new SubListBean();
	
				prevDate = rs.getString("KEY_DATE");

				subListBean = new SubListBean();
				subListBean.setInTime(rs.getString("ACTUAL ARRIVAL"));
				subListBean.setOutTime(rs.getString("ACTUAL DEPARTURE"));	
				subListBean.setBranchName(rs.getString("HUB_NAME"));
				subListBean.setDuration(rs.getDouble("DURATION"));
				subList.add(subListBean);
			}
		}
	}
		if(tripCount<subList.size()){
			tripCount = subList.size();
            }
		//subList.add(subListBean);
		
		if(tripCount>0 && finalList.size()>0)
		{
			innerhashmap.put(prevDate, subList);		
			finalList.set(0, tripCount);
			finalList.add(innerhashmap);
			tripDetailsObj.put(regNo,finalList);
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
	
	
	return tripDetailsObj;	
	}
	
	public boolean CheckImpreciseSetting(int userId, int systemId ) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt2=null;
		ResultSet rs2=null;
		boolean isimprecise = false;
		boolean locset = false;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(CommonStatements.CHECK_SYSTEM_MASTER_FOR_PRECISE_SETTING);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if(rs.getString("Location_Setting").equals("1")){
				locset = true;
				}else{
					locset = false;	
				}
				if(locset == true){
				
					pstmt2=conAdmin.prepareStatement(CommonStatements.CHECK_USERS_FOR_PRECISE_SETTING);
					pstmt2.setInt(1, systemId);
					pstmt2.setInt(2, userId);
					rs2 = pstmt2.executeQuery();
					if(rs2.next()){						
						if(rs2.getString("Location_Setting").equals("1")){
							isimprecise = true;	
							}else{
							isimprecise = false;	
							}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return isimprecise;
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
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
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
		} catch (Exception e) {		
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return distanceConversionFactor;
	}
	public String initializeDistanceUnitName(int SystemId, Connection con,String registrationNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String distanceUnitName;
		double distanceConversionFactor;
		double distCorrectionFactor;
		distanceConversionFactor = 1.0;
		distanceUnitName = "kms";
		try {
			pstmt = con.prepareStatement(CommonStatements.GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE);
			pstmt.setInt(1, SystemId);
			pstmt.setString(2, registrationNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				distanceUnitName = rs.getString("UnitName");
				distanceConversionFactor = rs.getDouble("ConversionFactor");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return distanceUnitName;
	}

	public boolean CheckImpreciseSettingForSystem(int systemId ) {
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;		
		boolean locset = false;
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(CommonStatements.CHECK_SYSTEM_MASTER_FOR_PRECISE_SETTING);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if(rs.getString("Location_Setting").equals("1")){
				locset = true;
				}else{
					locset = false;	
				}				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return locset;
	}
	public void insertDataIntoAuditLogReport(String sessionId,ArrayList<String> tableNames,String pageName,String action,int userId,String serverName,
			int systemId,int custId,String Remarks){
		//t4u506 start and end times
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int ID=0;
		String tableName="";
		String TableAction="";
		try {
			conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=conAdmin.prepareStatement(AdminStatements.INSERT_INTO_AUDIT_LOG_DETAILS,PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, sessionId);
			pstmt.setString(2, pageName);
			pstmt.setString(3, action);
			pstmt.setString(4, serverName);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, custId);
			pstmt.setString(8, Remarks);
			
			
			int updated = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if(rs.next())
			{
				ID = rs.getInt(1);
			}
			if(tableNames!=null){
			for(int i=0;i < tableNames.size();i++){
				if(tableNames.get(i)!=null){
					String[] names=tableNames.get(i).split("##");
					tableName=names[1];
					TableAction=names[0];
				}
				if(updated>0){
					pstmt=conAdmin.prepareStatement(AdminStatements.INSERT_INTO_AUDIT_LOG_ACTION_DETAILS);
					pstmt.setInt(1, ID);
					pstmt.setString(2, tableName);
					pstmt.setString(3, TableAction);
					int ins=pstmt.executeUpdate();
					if(ins>0){
					}
				}	
			}
			}
				
		} catch (Exception e) {
			System.out.println("Exception in AdminFunctions:-insertDataIntoAuditLogReport "+e.toString());
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
	}	
	
	public String getCoordinates(int systemId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String latLng="";
		String lat = "";
		String lng = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_COORDINATES_BASED_ON_SYSTEM_ID);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				
				lat = rs.getString("Latitude");
				lng = rs.getString("Longitude");
				if (lat.equals("0.0") || lng.equals("0.0")) {
					latLng = "23.524681, 77.810561";
				} else {
					latLng = lat + ", " + lng;
				}
			}
		} catch (Exception e) {
			System.out.println("Error"+e.toString());
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return latLng;
	}
	
	
	

	public String getCurrentDateTime(int offSet){
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet resultSet = null;
		String date="";
		String formattedDate = "";
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDate1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		try {
			connection = DBConnection.getConnectionToDB("AMS");
			Calendar cal=Calendar.getInstance();			
			cal.add(Calendar.MINUTE,+offSet);
			pstmt = connection.prepareStatement("SELECT dateadd(mi,?,getUTCDATE()) AS DateHourMinuteSecond");
			pstmt.setInt(1, offSet);
			resultSet = pstmt.executeQuery();
			while (resultSet.next()) {
				//date=resultSet.getString("DateHourMinuteSecond");				
				formattedDate = sdfFormatDate.format(resultSet.getTimestamp("DateHourMinuteSecond"));				
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, resultSet);
		}
		return formattedDate;
	}

	public void updateVehicleStatus(Connection con,String vehicleNo, int status, int tripId, LogWriter logWriter) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		logWriter.log("Inside Vehicle Status Updation. Vehicle No : "+vehicleNo+" and Trip Id : "+tripId+", Status : "+status, LogWriter.INFO);
		try{
			if(con == null){
				con = DBConnection.getConnectionToDB("AMS");
			}
			synchronized (lock){
				pstmt = con.prepareStatement(CommonStatements.CHECK_VEHICLE_STATUS);
				pstmt.setString(1, vehicleNo);
				rs = pstmt.executeQuery();
				if(rs.next()){
					if(con == null){
						con = DBConnection.getConnectionToDB("AMS");
					}
					pstmt = con.prepareStatement(CommonStatements.MOVE_TO_HISTORY);
					pstmt.setString(1, vehicleNo);
					pstmt.executeUpdate();
					
					pstmt = con.prepareStatement(CommonStatements.UPDATE_VEHICLE_STATUS);
					pstmt.setInt(1, status);
					pstmt.setInt(2, tripId);
					pstmt.setString(3, vehicleNo);
					pstmt.executeUpdate();
					
					logWriter.log("Vehicle Status Updated. Vehicle No : "+vehicleNo+" and Trip Id : "+tripId+", Status : "+status, LogWriter.INFO);
				}else{
					if(con == null){
						con = DBConnection.getConnectionToDB("AMS");
					}
					pstmt = con.prepareStatement(CommonStatements.INSERT_INTO_VEHICLE_STATUS);
					pstmt.setInt(1, status);
					pstmt.setString(2, vehicleNo);
					pstmt.setInt(3, tripId);
					pstmt.executeUpdate();
					
					logWriter.log("Vehicle Status Added. Vehicle No : "+vehicleNo+" and Trip Id : "+tripId+", Status : "+status, LogWriter.INFO);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			logWriter.log("Exception is updating vehicle status. Exception is : "+ e.getMessage()+" Vehicle No : "+vehicleNo+" and Trip Id : "+tripId, LogWriter.ERROR);
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
	}
	
	public void updateVehicleStatus(Connection con,String vehicleNo, int status, int tripId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = con.prepareStatement(CommonStatements.CHECK_VEHICLE_STATUS);
			pstmt.setString(1, vehicleNo);
			rs = pstmt.executeQuery();
			if(rs.next()){
				pstmt = con.prepareStatement(CommonStatements.MOVE_TO_HISTORY);
				pstmt.setString(1, vehicleNo);
				pstmt.executeUpdate();
				
				pstmt = con.prepareStatement(CommonStatements.UPDATE_VEHICLE_STATUS);
				pstmt.setInt(1, status);
				pstmt.setInt(2, tripId);
				pstmt.setString(3, vehicleNo);
				pstmt.executeUpdate();
			}else{
				pstmt = con.prepareStatement(CommonStatements.INSERT_INTO_VEHICLE_STATUS);
				pstmt.setInt(1, status);
				pstmt.setString(2, vehicleNo);
				pstmt.setInt(3, tripId);
				pstmt.executeUpdate();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
	}
	
	 public String checkForDataAvailability(int systemId, int clientId, int offset, int userId,String date1,String date2, String regNo){
		 JSONObject JsonObject = new JSONObject();
			Connection con = null;
		 PreparedStatement pstmt = null;
    	 ResultSet rs = null;
    	 List<JSONObject>expList =null;
    	 String message  = null;
    	 Date date = new Date();
    	 SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	 try{
    		 con = DBConnection.getConnectionToDB("AMS");
    		 pstmt=con.prepareStatement(CommonStatements.GET_DOOR_SENSOR_ACTIVITY_REPORT);
    		 pstmt.setInt(1, offset);
 			pstmt.setString(2, regNo);
 			pstmt.setInt(3, offset);
 			pstmt.setString(4, date1);
 			pstmt.setInt(5, offset);
 			pstmt.setString(6, date2);
 			pstmt.setInt(7, offset);
 			pstmt.setString(8, regNo);
 			pstmt.setInt(9, offset);
 			pstmt.setString(10, date1);
 			pstmt.setInt(11, offset);
 			pstmt.setString(12, date2);
		    rs = pstmt.executeQuery();
		    expList = new ArrayList<JSONObject>();
		    String reffer="";
		    int count=0;
		    if(rs.next()){
		    	message = "Records Found";
		    }else{
		    	message = "No Records Found";
		    }
    		 	      
    	 }catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		 return message;
	 }
	 
	 public JSONArray getListViewColumnSetting(int systemId, int customerId, int userId, String pageName){
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
 		 	pstmt=con.prepareStatement(CommonStatements.GET_LIST_VIEW_COLUMN_SETTING);
 		 	pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			pstmt.setString(4, pageName);
		    rs = pstmt.executeQuery();
		    expList = new ArrayList<JSONObject>();
		    String reffer="";
		    int count=0;
		    while(rs.next()){
		    	jsonObject = new JSONObject();
		    	jsonObject.put("id", rs.getString("ID"));
		    	jsonObject.put("columnName", rs.getString("COLUMN_NAME"));
		    	jsonObject.put("visibility", (Integer.parseInt(rs.getString("VISIBILITY"))==1)? "true":"false");
		    	array.put(jsonObject);
		    }
 		 	      
 	 	}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	 }
	 
	 
	 public JSONArray updateListViewColumnSetting(int systemId, int customerId, int userId,List settingsList){
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
	 		pstmt=con.prepareStatement(CommonStatements.UPDATE_LIST_VIEW_COLUMN_SETTING);
	 		 for(int i=0; i <settingsList.size(); i++){ //Implement batch update
	 			LinkedTreeMap map = (LinkedTreeMap)settingsList.get(i);
//	 		 	pstmt=con.prepareStatement(CommonStatements.UPDATE_LIST_VIEW_COLUMN_SETTING);
	 		 	pstmt.setInt(1, (map.get("visibility").toString().equals("true"))?1 :0);
	 			pstmt.setInt(2, Integer.parseInt(map.get("id").toString()));
	 		 	pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, userId);
//			    pstmt.executeUpdate();
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
	 
	 public JSONArray insertListViewColumnSetting(int systemId, int customerId, int userId,List settingsList,String pageName){
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
	 		pstmt=con.prepareStatement(CommonStatements.INSERT_LIST_VIEW_COLUMN_SETTING);
	 		 for(int i=0; i <settingsList.size(); i++){ //Implement batch update
	 			LinkedTreeMap map = (LinkedTreeMap)settingsList.get(i);
//	 		 	pstmt=con.prepareStatement(CommonStatements.UPDATE_LIST_VIEW_COLUMN_SETTING);
	 		 	pstmt.setString(1, pageName);
	 			pstmt.setString(2, map.get("columnName").toString());
	 			pstmt.setInt(3, (map.get("visibility").toString().equals("true"))?1 :0);
	 		 	pstmt.setInt(4, systemId);
				pstmt.setInt(5, customerId);
				pstmt.setInt(6, userId);
//			    pstmt.executeUpdate();
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
		public String convertMillisecondsToHHMMSSFormat(long millis) 
		{
			String duration="";
			long seconds = millis / 1000;
	
			long s = seconds % 60;
			long m = (seconds / 60) % 60;
			long h = (seconds / (60 * 60));
			duration = String.format("%02d:%02d:%02d", h, m, s);
			
			return duration;
		}
		public String convertMinutesToHHMMSSFormat(long minutes) 
		{
			
			String duration="";
			long seconds = minutes * 60;
			long s = seconds % 60;
			long m = (seconds / 60) % 60;
			long h = (seconds / (60 * 60));
			duration = String.format("%02d:%02d:%02d", h, m, s);
			
			return duration;
		}
		
		public  String formattedHoursMinutesSeconds(long diff) {
			String hhmmssformat="";
			String format="";
			boolean negative=false;
			try {
				diff=(diff*60)*1000;
				if(diff==0){
					return hhmmssformat="";
				}
				long diffSeconds = diff / 1000 % 60;
				long diffMinutes = diff / (60 * 1000) % 60;
				long diffHours = diff / (60 * 60 * 1000);
				//hhmmssformat=diffHours+":"+diffMinutes+":"+diffSeconds;
				hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
				negative = hhmmssformat.contains("-")?true:false;
				format=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;
			} catch (Exception e) {
				System.out.println("hh:mm:ss exception :::::   "+e.getLocalizedMessage());
				e.printStackTrace();

			}
			return format;

		}
		
		
		public void insertDataIntoAuditLogReportMaps(String sessionId,ArrayList<String> tableNames,String pageName,String action,int userId,String serverName,
				int systemId,int custId,String Remarks, String reqStartTime,String reqEndTime){
			//t4u506 start and end times
			Connection conAdmin=null;
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			int ID=0;
			String tableName="";
			String TableAction="";
			try {
				conAdmin=DBConnection.getConnectionToDB("ADMINISTRATOR");
				pstmt=conAdmin.prepareStatement(AdminStatements.INSERT_INTO_AUDIT_LOG_DETAILS_MAPLOGS,PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, sessionId);
				pstmt.setString(2, pageName);
				pstmt.setString(3, action);
				pstmt.setString(4, serverName);
				pstmt.setInt(5, userId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, custId);
				pstmt.setString(8, Remarks);
				pstmt.setString(9, reqStartTime);  //t4u506
				pstmt.setString(10, reqEndTime);   //t4u506
				
				int updated = pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();
				if(rs.next())
				{
					ID = rs.getInt(1);
				}
				if(tableNames!=null){
				for(int i=0;i < tableNames.size();i++){
					if(tableNames.get(i)!=null){
						String[] names=tableNames.get(i).split("##");
						tableName=names[1];
						TableAction=names[0];
					}
					if(updated>0){
						pstmt=conAdmin.prepareStatement(AdminStatements.INSERT_INTO_AUDIT_LOG_ACTION_DETAILS);
						pstmt.setInt(1, ID);
						pstmt.setString(2, tableName);
						pstmt.setString(3, TableAction);
						int ins=pstmt.executeUpdate();
						if(ins>0){
						}
					}	
				}
				}
					
			} catch (Exception e) {
				System.out.println("Exception in AdminFunctions:-insertDataIntoAuditLogReport "+e.toString());
				e.printStackTrace();
			}
			finally{
				DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			}
		}	
		public   String getGMT(Date inputDate,int offSet){
			String retValue="";
			Date convDate=null;
			convDate=inputDate;
			if(convDate!=null){
			Calendar cal=Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE,-offSet);


			int day=cal.get(Calendar.DATE);
			int y=cal.get(Calendar.YEAR);
			int m=cal.get(Calendar.MONTH)+1;
			int h=cal.get(Calendar.HOUR_OF_DAY);
			int mi=cal.get(Calendar.MINUTE);
			int s=cal.get(Calendar.SECOND);

			String yyyy=String.valueOf(y);
			String month=String.valueOf(m>9?String.valueOf(m):"0"+String.valueOf(m));
			String date=String.valueOf(day>9?String.valueOf(day):"0"+String.valueOf(day));
			String hour=String.valueOf(h>9?String.valueOf(h):"0"+String.valueOf(h));
			String minute=String.valueOf(mi>9?String.valueOf(mi):"0"+String.valueOf(mi));
			String second=String.valueOf(s>9?String.valueOf(s):"0"+String.valueOf(s));

			retValue = yyyy+"-"+month+"-"+date+" "+hour+":"+minute+":"+second;
			}
			return retValue;
			} 

		public static String convertListToSqlINParam(List<String> list){
			StringBuffer sb = new StringBuffer();
			String str= new String();
			for(String id : list){
				sb.append(id);
				sb.append(",");
			}
			if(sb.lastIndexOf(",") >0){
				str = sb.substring(0, sb.lastIndexOf(","));
			}
			return str;
		}
		
		public static String getSqlParams(int numParams) {
		    StringBuilder sb = new StringBuilder();
		    if(numParams <= 0) return sb.toString();
		    for(int ctr = 0; ctr < numParams - 1; ++ctr) {
		        sb.append("?,");
		    }
		    sb.append("?");
		    return sb.toString();
		}

		public void pushData(JSONObject object, int count,HttpURLConnection connection,Connection con ) throws SQLException {
			
			ArrayList<String> apiDetails = getAPIConfiguration(con, "Trip_Exec");
			Properties properties = ApplicationListener.prop;
			String url = properties.getProperty("remarksApiUrl");
			String authorization = properties.getProperty("remarksApiAuthorization");
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			LogWriter logWriter = null;
			PrintWriter pw = null;
			
			String logFile = properties.getProperty("APILogs");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;
			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("APILogs", LogWriter.INFO, pw);
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead", LogWriter.ERROR);
				}
			}
			if (connection == null) {
				try {
					connection = preprocess(properties, url, authorization);
				} catch (Exception e1) {
					logWriter.log("An exception occured while creating the HttpURLConnection... Returning without pushing data..", LogWriter.ERROR);
					e1.printStackTrace();
					return;
				}
			}
			try {
				OutputStream os = connection.getOutputStream();
				os.write(object.toString().getBytes());
				os.flush();
			} catch (IOException e1) {
				logWriter.log("An exception occured while flushing the payload... trying to push again..", LogWriter.ERROR);
				e1.printStackTrace();
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				if (++count < 2) {
					pushData(object, count, connection,con);
				}
			} finally {
				try {
					logWriter.log("The JSON pushed is:: " + object.toString() + "", LogWriter.INFO);
					if (connection.getResponseCode() == 200) {
						logWriter.log("Resource data pushed successfully...", LogWriter.INFO);
					} else if ((connection.getResponseCode() == 408) && (++count < 5)) { // 408 Request Timeout
						logWriter.log("Received 408 Request Timeout.. So, attempting to push the data again..", LogWriter.ERROR);
						pushData(object, count, connection,con);
					} else {
						logWriter.log("Resource data push FAILED... Tried to push the data " + count + " times.. " + "The Response Code is:: " + connection.getResponseCode(),
								LogWriter.ERROR);
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
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

		private static HttpURLConnection preprocess(Properties properties, String URL, String authorization) throws JSONException, MalformedURLException,
				IOException, ProtocolException {
			HttpURLConnection connection;
			URL url = new URL(URL);
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Authorization", authorization);
			connection.setRequestProperty("X-Requested-With", "X");
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setDoOutput(true);
			connection.setInstanceFollowRedirects(false);
			return connection;
		}
		
		
		public boolean checkForRoleBasedMenu(int systemId,int customeridlogged ) {
			
			/*This method is to check whether menu should populate based on configurations(i.e., ROLE_BASED_MENU) 
			done at AMS.dbo.System_Master and ADMINISTRATOR.dbo.CUSTOMER_MASTER*/
			Connection con =null;
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			PreparedStatement pstmt1=null;
			ResultSet rs1=null;
			 
			boolean roleBased = false;
			try {
				con =DBConnection.getConnectionToDB("ADMINISTRATOR");
				
				pstmt=con.prepareStatement(CommonStatements.GET_SYSTEM_MASTER_DETAILS_BY_SYSTEM_ID);
				pstmt.setInt(1, systemId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					System.out.println(" RBM :: "+rs.getString("ROLE_BASED_MENU"));
					 if (rs.getString("ROLE_BASED_MENU").equalsIgnoreCase("YES")){
						 if (customeridlogged == 0){  // LTSP usres default role based if true at System-Master table
								return true;
							}else{
								pstmt1=con.prepareStatement(CommonStatements.GET_CUSTOMER_MASTER_DETAILS_BY_CUSTOMER_ID);
								pstmt1.setInt(1, customeridlogged);
								rs1 = pstmt1.executeQuery();
								if (rs1.next()) {
									if (rs1.getString("ROLE_BASED_MENU").equalsIgnoreCase("YES")){
										roleBased = true;
									}
								}
							}
						
					}else{
						return false;
					}
				}
				 
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return roleBased;
		}
		
		public Integer getRoleIdByUserId(Connection con,int systemId,int userId) {
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			int roleId = 0;
			try {
				pstmt=con.prepareStatement(CommonStatements.GET_ROLE_ID_DETAILS_BY_USER_ID);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					roleId = rs.getInt("ROLE_ID");
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			return roleId;
		}
		public String getRoleIdFromUsersWithoutConnection(int systemId, int userId){
			String roleId = "";
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try{
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select isnull(FmsUserAuthority,'') as ROLE_ID from Users where System_id=? and User_id=?");
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				rs = pstmt.executeQuery();
				if(rs.next()){
					roleId = rs.getString("ROLE_ID");
				}
			}catch(Exception e){
				System.out.println("Exception occurred while fetching the Role Id from Users : Telematics4uApp --> " +
						"CommonFunctions.java --> getRoleName()");
			}finally{
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return roleId;
		}

		public boolean updateUpcomingTripStatusToOpen(Connection con, String vehicleNo, int tripId, int clientId, LogWriter logWriter) throws SQLException {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			final String UPDATE_UPCOMING_TRIP_STATUS = "update TRACK_TRIP_DETAILS set STATUS='OPEN' where TRIP_ID in " +
			"(select top 1 TRIP_ID from TRACK_TRIP_DETAILS (nolock) where ASSET_NUMBER=? and TRIP_ID > ? and STATUS='UPCOMING' " +
			"and CUSTOMER_ID=? order by TRIP_ID)";
			
			pstmt = con.prepareStatement(UPDATE_UPCOMING_TRIP_STATUS);
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, tripId);
			pstmt.setInt(3, clientId);
			int update = pstmt.executeUpdate();
			if(update > 0){
				logWriter.log("Updated the upcoming trip to OPEN for the vehicle : "+vehicleNo+", Trip Id :"+tripId, LogWriter.INFO);
				return true;
			}else{
				logWriter.log("Could not find any upcoming trip for the vehicle : "+vehicleNo+", Trip Id :"+tripId, LogWriter.INFO);
			}
			return false;
		}

	public void SAPAPICall(String tripName, String succesorId, String eventCode, String endLoc, int count,
			LogWriter logWriter, String urlData, String auth, String eventDate) {
		JSONObject obj = new JSONObject();
		JSONArray resultsArr1 = new JSONArray();
		JSONObject resultObj1 = new JSONObject();
		JSONObject headerStageObj = new JSONObject();
		JSONObject finalObject = new JSONObject();
		SimpleDateFormat ddmmyyyyHHmmssSAP = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
		SimpleDateFormat sfddMMYYYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		try {
			Date date = new Date();
			//Date is expecting to come in the format of dd/MM/yyyy HH:mm:ss
			if (!eventDate.contains("1900") && !eventDate.equals("")) {
				date = sfddMMYYYY.parse(eventDate);
			}
			if (endLoc.contains("-")) {
				endLoc = endLoc.substring(endLoc.indexOf("-") + 1, endLoc.length());
			}
			obj.put("TorId", tripName);
			obj.put("SuccessorId", succesorId);
			obj.put("EventType", "E");
			obj.put("EventCode", eventCode);
			obj.put("RepDatetimeLocal", ddmmyyyyHHmmssSAP.format(date));
			obj.put("Locid1", endLoc);
			obj.put("GpsRead", "Read1");
			resultsArr1.put(obj);
			resultObj1.put("results", resultsArr1);
			headerStageObj.put("EXECHDR", resultObj1);

			JSONObject obj1 = new JSONObject();
			JSONArray resultArr2 = new JSONArray();
			JSONObject resultObj2 = new JSONObject();

			obj1.put("TorId", tripName);
			obj1.put("Locid", "");
			obj1.put("Eta", "");
			resultArr2.put(obj1);

			resultObj2.put("results", resultArr2);
			headerStageObj.put("EXECSTAGE", resultObj2);

			finalObject.put("d", headerStageObj);

			String status = "";

			HttpURLConnection connection = null;
			URL url = new URL(urlData);
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Authorization", auth);
			connection.setRequestProperty("X-Requested-With", "X");
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setDoOutput(true);
			connection.setInstanceFollowRedirects(false);

			OutputStream os = connection.getOutputStream();
			os.write(finalObject.toString().getBytes());
			os.flush();
			status = Integer.toString(connection.getResponseCode());
			if ("201".equals(status)) {
				logWriter.log("Trip Execution Called to SAP successfully : " + finalObject + ". Status : " + status,
						LogWriter.INFO);
			} else {
				logWriter.log("Failed to push Trip Execution data: " + finalObject + ". Status : " + status,
						LogWriter.INFO);
				if (count <= 0) {
					SAPAPICall(tripName, succesorId, eventCode, endLoc, ++count, logWriter, urlData, auth, eventDate);
				} else {
					insertIntoAuditLog(logWriter, tripName, finalObject.toString());
				}
			}
		} catch (final Exception e) {
			insertIntoAuditLog(logWriter, tripName, finalObject.toString());
		}
	}

		private void insertIntoAuditLog(LogWriter logWriter, String tripName, String jsonObject) {
			PreparedStatement pstmt = null;
			Connection con = null;
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("insert into API_AUDIT_LOG (TRIP_NO,JSON,STATUS,INSERTED_DATETIME) values (?,?,'N',GETDATE()) ");
				pstmt.setString(1, tripName);
				pstmt.setString(2, jsonObject);
				int i = pstmt.executeUpdate();
				if (i > 0) {
					logWriter.log("Successfully inserted Failed Logs  into Audit log !",LogWriter.INFO);
				} else {
					logWriter.log("Error in inserting Failed Logs  into Audit log !",LogWriter.ERROR);
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, null);
			}
		}
		
		public void updateTripATADetailsInSLAReport(String tripId, String ata, LogWriter logWriter, Connection con) throws SQLException, ParseException {
			PreparedStatement pstmt;
			pstmt = con.prepareStatement(GeneralVerticalStatements.UPDATE_SLA_TRIP_WISE_ATA);
			pstmt.setString(1, sdfDB.format(sdf.parse(ata)));
			pstmt.setString(2, tripId);
			int i = pstmt.executeUpdate();
			if (i == 1) {
				logWriter.log("************ Trip Wise ATA Updated Successfully   ***************", LogWriter.INFO);
			} else {
				logWriter.log("************ Error in Updating Trip Wise  ***************", LogWriter.ERROR);
			}
			DBConnection.releaseConnectionToDB(null, pstmt, null);
		}
		
		public void updateLegDetailsInSLAReport(String tripId, String ata, LogWriter logWriter, Connection con) throws SQLException, ParseException {
			PreparedStatement pstmtLeg = null;
			ResultSet rsLeg = null;
			PreparedStatement pstmtUpdate = null;
			pstmtUpdate = con.prepareStatement(GeneralVerticalStatements.UPDATE_SLA_LEG_WISE_ATA);
			pstmtUpdate.setString(1, sdfDB.format(sdf.parse(ata)));
			pstmtUpdate.setString(2, tripId);
			int i = pstmtUpdate.executeUpdate();
			if (i > 0) {
				logWriter.log(" Leg Wise ATA Updated Successfully!!!!!! ", LogWriter.INFO);
			} else {
				logWriter.log(" Error in Updating Leg Wise ", LogWriter.ERROR);
			}
		
			DBConnection.releaseConnectionToDB(null, pstmtLeg, rsLeg);
			DBConnection.releaseConnectionToDB(null, pstmtUpdate, null);
		}

		public void insertDataIntoAuditLogReport(String pageName, StringBuilder action, int userId, int systemId, int clientId,
				String serverName,int tripId,String remarks) {
			Connection conAdmin = null;
			PreparedStatement pstmt = null;
			try{
				conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
				pstmt = conAdmin.prepareStatement("insert into ADMINISTRATOR.dbo.AUDIT_LOG_DETAILS(PAGE_NAME,ACTION,SERVER,USER_ID,SYSTEM_ID," +
						"CUSTOMER_ID,INSERTED_DATETIME,TRIP_ID,REMARKS) values(?,?,?,?,?,?,getutcdate(),?,?)");
				pstmt.setString(1, pageName);
				pstmt.setString(2, action.substring(0,action.length()-1).toString());
				pstmt.setString(3, serverName);
				pstmt.setInt(4, userId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, clientId);
				pstmt.setInt(7, tripId);
				pstmt.setString(8, remarks);
				pstmt.executeUpdate();
			}catch(final Exception e){
				e.printStackTrace();
			}
			
		}
		
		public StringBuffer getExtList(int start, int end) {
			StringBuffer strlist = new StringBuffer();
			for (Integer i = start; i < end; i++) {
				strlist.append("\"" + String.format("%02d", i) + "\",");
			}
			if (strlist != null && strlist.length() > 0) {
				strlist.delete(strlist.length() - 1, strlist.length());
			}
			return strlist;
		}
		
		
		public JSONObject getTripCustomerDetails(Connection con,Integer id){
			JSONObject jsonObject = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try{
				pstmt = con.prepareStatement(CommonStatements.GET_TRIP_CUSTOMER_DETAILS_BY_ID);
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();
				if (rs.next()){
					jsonObject = new JSONObject();
					jsonObject.put("ID", rs.getInt("ID"));
					jsonObject.put("NAME", rs.getString("NAME"));
					jsonObject.put("SYSTEM_ID", rs.getInt("SYSTEM_ID"));
					jsonObject.put("CUSTOMER_ID", rs.getInt("CUSTOMER_ID"));
					jsonObject.put("INSERTED_DATETIME", rs.getString("INSERTED_DATETIME"));
					jsonObject.put("CONTACT_PERSON", rs.getString("CONTACT_PERSON"));
					jsonObject.put("CONTACT_NO", rs.getString("CONTACT_NO"));
					jsonObject.put("CONTACT_ADDRESS", rs.getString("CONTACT_ADDRESS"));
					jsonObject.put("CUSTOMER_REFERENCE_ID", rs.getString("CUSTOMER_REFERENCE_ID"));
					jsonObject.put("STATUS", rs.getString("STATUS"));
					jsonObject.put("TYPE", rs.getString("TYPE"));
				}

			}catch (Exception e) {
				e.printStackTrace();
			}finally{
				DBConnection.releaseConnectionToDB(null, pstmt, rs);
			}
			return jsonObject;
		}

	public JSONArray getCityNamesForMap(String isCapital) {
		JSONObject jsonObject = null;
		JSONArray jsonArr = new JSONArray();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			if(isCapital!=null && Boolean.parseBoolean(isCapital)) {
				pstmt = con.prepareStatement(CommonStatements.GET_CITY_NAMES.concat(" where CITY_TYPE='CAPITAL'"));
			} else {
				pstmt = con.prepareStatement(CommonStatements.GET_CITY_NAMES.concat(" where isnull(CITY_TYPE,'')!='CAPITAL'"));
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("cityName", rs.getString("CITY_NAME"));
				jsonObject.put("latitude", rs.getString("LATITUDE"));
				jsonObject.put("longitude", rs.getString("LONGITUDE"));
				jsonObject.put("capital", rs.getString("CITY_TYPE"));
				jsonObject.put("iconName", rs.getString("ICON_NAME"));
				jsonObject.put("iconLink", rs.getString("ICON_LINK"));
				jsonObject.put("utcTime", rs.getString("UTC_TIME"));
				jsonObject.put("visibility", rs.getString("VISIBILITY"));
				jsonObject.put("temperature", rs.getString("TEMPERATURE"));
				jsonObject.put("desc", rs.getString("DESCRIPTION"));
				jsonObject.put("severeDesc", rs.getString("SEVERE_WEATHER_DESCRIPTION"));
				
				jsonArr.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArr;
	}
		
	public Coordinate[] getPolygonLocation(int hubId, Connection con) {
		ArrayList<Coordinate> PolygonDetails = new ArrayList<Coordinate>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		final String GET_POLYGON_LOCATION_DETAILS = "select LATITUDE,LONGITUDE,HUBID from POLYGON_LOCATION_DETAILS where HUBID=? order by SEQUENCE_ID";
		Coordinate[] PolygonDetailsArray = null;
		try {
			pstmt = con.prepareStatement(GET_POLYGON_LOCATION_DETAILS);
			pstmt.setInt(1, hubId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				if (rs.getString("LATITUDE") != null && rs.getString("LONGITUDE") != null) {
					Coordinate coord = new Coordinate(rs.getDouble("LONGITUDE"), rs.getDouble("LATITUDE"));
					PolygonDetails.add(coord);
				}
			}

			if (PolygonDetails.size() > 1) {
				PolygonDetailsArray = new Coordinate[PolygonDetails.size() + 1];
				int i = 0;

				for (i = 0; i < PolygonDetails.size(); i++) {
					PolygonDetailsArray[i] = (Coordinate) PolygonDetails.get(i);
				}

				PolygonDetailsArray[i] = (Coordinate) PolygonDetails.get(0);
			}
		}

		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return PolygonDetailsArray;
	}

	public Integer[] getActiveUserCount(int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Integer[] countArray = new Integer[2];
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_ACTIVE_USERS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("type").equals("web")) {
					countArray[0] = rs.getInt("count");
				}
				if (rs.getString("type").equals("mobile")) {
					countArray[1] = rs.getInt("count");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return countArray;
	}
	
	//THIS METHOD IS TO FECTH THE STOCKYARDS //
	public JSONArray getStockYards(int SystemId,int ClientId){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(CommonStatements.GET_STOCKYARDS);
			pstmt.setInt(1, SystemId);
			pstmt.setInt(2, ClientId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("stockYardId", rs.getString("UniqueId"));
				jsonObject.put("stocksYardName", rs.getString("Port_Name"));
				//jsonObject.put("stocksYardName", rs.getString("Port_Name").split(",")[0]);
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getStockYards "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}

	public JSONArray getLiveVisionSettings(int systemId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jArr = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CommonStatements.GET_LIVEVISION_SETTINGS);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("runningDuration", rs.getInt("RUNNING_DURATION") * 1000);
				obj.put("idleDuration", rs.getInt("IDLE_DURATION") * 1000);
				obj.put("stoppageDuration", rs.getInt("STOPPAGE_DURATION") * 1000);
				jArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jArr;

	}
 	}