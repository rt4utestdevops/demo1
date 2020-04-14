package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.FCISStatements;


/**
 * this is common function class for FCIS Module
 * @author ashutoshk
 *
 */
public class FCISFunctions {
	SimpleDateFormat sdfddmmyy=new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfddmmyyhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	
	@SuppressWarnings("unchecked")
	/**
	 * function will take following parameters and will return Fuel Consolidated Report record
	 * @param systemId
	 * @param customerId
	 * @param groupId
	 * @param startDate
	 * @param endDate
	 * @param language
	 * @return
	 */
	public ArrayList getFuelConsolidatedReport(int systemId, String customerId,
		 String groupId, String startDate, String endDate, String language, int offset,int userId) {
		SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYEXP = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		 ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		 ArrayList<String> headersList = new ArrayList<String>();
		 ReportHelper finalreporthelper = new ReportHelper();
		 ArrayList<Object> finlist = new ArrayList<Object>();
		 //adding Header List data in headerlist array to print in Excel And PDF
		 ArrayList<String> tobeConverted=new ArrayList<String>();
		 tobeConverted.add("SLNO");
		 tobeConverted.add("Registration_No");
		 tobeConverted.add("Vehicle_Model");
		 tobeConverted.add("Tank_Capacity");
		 tobeConverted.add("Refuel_Date_Time");
		 tobeConverted.add("Refuel_L");
		 tobeConverted.add("Location");
		 tobeConverted.add("Distance_Travelled_BW_Two_Refuels");
		 tobeConverted.add("Fuel_Consumed_BW_Two_Refuels");
		 tobeConverted.add("Mileage_BW_Two_Refuels");
		 ArrayList<String> convertedWords=new ArrayList<String>();
		 convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
		 headersList.add(convertedWords.get(0));
		 headersList.add(convertedWords.get(1));
		 headersList.add(convertedWords.get(2));
		 headersList.add(convertedWords.get(3));
		 headersList.add(convertedWords.get(4));
		 headersList.add(convertedWords.get(5));
		 headersList.add(convertedWords.get(6));
		 headersList.add(convertedWords.get(7));
		 headersList.add(convertedWords.get(8));
		 headersList.add(convertedWords.get(9));
		
		 JSONArray jsonArray = new JSONArray();
		 JSONObject jsonObject = new JSONObject();
		 Connection conAms=null;
		 PreparedStatement pstmt=null;
		 ResultSet rs=null;
		 int count = 0;
		 try {

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				conAms=DBConnection.getConnectionToDB("AMS");
				
				if (startDate.contains("T")) {
					startDate = startDate.substring(0, startDate.indexOf("T"))
					+ " "
					+ startDate.substring(startDate.indexOf("T") + 1,startDate.length());
					startDate = getFormattedDateStartingFromMonth(startDate);
					startDate = getLocalDateTime(startDate, offset);
				} else {
					java.util.Date start = simpleDateFormatddMMYY.parse(startDate);
					startDate = simpleDateFormatYYYY.format(start);
					startDate = getLocalDateTime(startDate, offset);
				}
				
				if (endDate.contains("T")) {
					endDate = endDate.substring(0, endDate.indexOf("T"))
					+ " "
					+ endDate.substring(endDate.indexOf("T") + 1,endDate.length());
					endDate = getFormattedDateStartingFromMonth(endDate);
					endDate = getLocalDateTime(endDate, offset);
				} else {
					java.util.Date start = simpleDateFormatddMMYY.parse(endDate);
					endDate = simpleDateFormatYYYY.format(start);
					endDate = getLocalDateTime(endDate, offset);
				}
				System.out.println("groupId:"+groupId);
				if (groupId.equals("2803")) {
					pstmt=conAms.prepareStatement(FCISStatements.GET_FUEL_CONSOLIDATED_REPORT_DATA.concat(" order by ri.GMT ASC"));
					pstmt.setString(1, startDate);
					pstmt.setString(2,endDate);
					pstmt.setInt(3,systemId); //systemId);
					pstmt.setString(4, customerId);//customerId);
					pstmt.setInt(5, userId);
				} else {
					pstmt=conAms.prepareStatement(FCISStatements.GET_FUEL_CONSOLIDATED_REPORT_DATA.concat(" and vc.GROUP_ID=? order by ri.GMT ASC"));
					pstmt.setString(1, startDate);
					pstmt.setString(2,endDate);
					pstmt.setInt(3,systemId); //systemId);					
					pstmt.setString(4, customerId);//customerId);
					pstmt.setInt(5, userId);
					pstmt.setString(6, groupId);//Integer.parseInt(groupId));
				}
				
				rs=pstmt.executeQuery();
				double distancetravelled = 0;
				double fuelConsumed = 0;
				double mileage = 0;
				while(rs.next()){
					jsonObject = new JSONObject();
					ArrayList informationList=new ArrayList();
					ReportHelper reporthelper=new ReportHelper();
					count++;
					
					informationList.add(Integer.toString(count));
					jsonObject.put("slnoIndex", Integer.toString(count));
					
					String REGISTRATION_NO=rs.getString("REGISTRATION_NO");
					jsonObject.put("VehicleNo", REGISTRATION_NO);
					informationList.add(REGISTRATION_NO);
					
					String Model_Name="";
					if(rs.getString("ModelName")!=null){
						Model_Name=rs.getString("ModelName");
					}
					jsonObject.put("VehicleModel", Model_Name);
					informationList.add(Model_Name);
					
					String TANK_CAPACITY="";
					if(rs.getString("FuelWhenTankIsFull")!=null){
						TANK_CAPACITY=rs.getString("FuelWhenTankIsFull");
					}
					jsonObject.put("TankCapacity", TANK_CAPACITY);
					informationList.add(TANK_CAPACITY);
					
					String Refuel_DATE_TIME=rs.getString("GMT");
					String Refuel_DATE_TIME_EXP = null;
					if (rs.getString("GMT") != null && !rs.getString("GMT").equals("")) {
						java.util.Date date = simpleDateFormatddMMYYYYDB.parse(Refuel_DATE_TIME);
						Refuel_DATE_TIME = simpleDateFormatYYYY.format(date);
						Refuel_DATE_TIME = AddOffsetToGmt(Refuel_DATE_TIME, offset);
						java.util.Date date1 = simpleDateFormatYYYY.parse(Refuel_DATE_TIME);
						Refuel_DATE_TIME_EXP = simpleDateFormatddMMYYEXP.format(date1);
						String substr = Refuel_DATE_TIME.substring(6, 10);
						if (substr.equals("1900")) {
							Refuel_DATE_TIME = "";
							Refuel_DATE_TIME_EXP = "";
						}
					} else {
						Refuel_DATE_TIME = "";
						Refuel_DATE_TIME_EXP = "";
					}
					
					jsonObject.put("RefuelDateTime", Refuel_DATE_TIME);
					informationList.add(Refuel_DATE_TIME_EXP);
					
					String REFUEL_LITRES="";
					if(rs.getString("REFUEL_IN_LIT")!=null){
						REFUEL_LITRES=rs.getString("REFUEL_IN_LIT");
					}
					jsonObject.put("RefuelLiters", REFUEL_LITRES);
					informationList.add(REFUEL_LITRES);
					
					String LOCATION="";
					if (rs.getString("LOCATION")!=null) {
						LOCATION=rs.getString("LOCATION");
					}
					jsonObject.put("Location", LOCATION);
					informationList.add(LOCATION);
					
					distancetravelled = rs.getDouble("Distance");
					jsonObject.put("DistanceTravelled", distancetravelled);
					informationList.add(distancetravelled);
					
					fuelConsumed = rs.getDouble("FuelConsumed");
					jsonObject.put("FuelConsumed", fuelConsumed);
					informationList.add(fuelConsumed);
					
					mileage = rs.getDouble("Mileage");
					if (fuelConsumed<0) {
						mileage = 0;
					}
					jsonObject.put("Mileage", mileage);
					informationList.add(mileage);
					
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
			System.out.println("Error in FCIS Functions:=");
		}finally{
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}	
		return finlist;
		
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
			String month = String.valueOf(m > 9 ? String.valueOf(m) : "0"+ String.valueOf(m));
			String date = String.valueOf(day > 9 ? String.valueOf(day) : "0"+ String.valueOf(day));
			String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0"+ String.valueOf(h));
			String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0"+ String.valueOf(mi));
			String second = String.valueOf(s > 9 ? String.valueOf(s) : "0"+ String.valueOf(s));
			retValue = month + "/" + date + "/" + yyyy + " " + hour + ":"+ minute + ":" + second;
		}
		return retValue;
	}
	
	public Date convertStringToDate(String inputDate) {
		Date dDateTime = null;
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				dDateTime = sdfFormatDate.parse(inputDate);
				java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime
						.getTime());
				dDateTime = timest;
			}
		} catch (Exception e) {
			System.out.println("Error in convertStringToDate method" + e);
			e.printStackTrace();
		}
		return dDateTime;
	}
	
	public String AddOffsetToGmt(String inputDate, int offSet) {
		String retValue = inputDate;
		Date convDate = null;
		convDate = convertStringToDate(inputDate);
		if (convDate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(convDate);
			cal.add(Calendar.MINUTE, +offSet);
			int day = cal.get(Calendar.DATE);
			int y = cal.get(Calendar.YEAR);
			int m = cal.get(Calendar.MONTH) + 1;
			int h = cal.get(Calendar.HOUR_OF_DAY);
			int mi = cal.get(Calendar.MINUTE);
			int s = cal.get(Calendar.SECOND);
			String yyyy = String.valueOf(y);
			String month = String.valueOf(m > 9 ? String.valueOf(m) : "0"+ String.valueOf(m));
			String date = String.valueOf(day > 9 ? String.valueOf(day) : "0"+ String.valueOf(day));
			String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0"+ String.valueOf(h));
			String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0"+ String.valueOf(mi));
			String second = String.valueOf(s > 9 ? String.valueOf(s) : "0"+ String.valueOf(s));
			retValue = month + "/" + date + "/" + yyyy + " " + hour + ":"+ minute + ":" + second;
		}
		return retValue;
	}
}
