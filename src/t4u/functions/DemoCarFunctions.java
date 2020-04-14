package t4u.functions;

import java.io.IOException;
import java.io.StringWriter;
import java.net.Inet4Address;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.math.*;



import org.apache.struts.util.LabelValueBean;
import org.json.JSONArray;
import org.json.JSONObject;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;


import t4u.beans.DriverTripDetailBean;
import t4u.beans.KLERequestBean;
import t4u.beans.ReportHelper;
import t4u.beans.AssetUtilizationBean;
import t4u.common.DBConnection;
import t4u.statements.AdminStatements;
import t4u.statements.DemoCarStatements;
import t4u.statements.EmployeetrackingStatements;
import t4u.statements.SchoolStatments;


@SuppressWarnings({"static-access","unchecked"})
public class DemoCarFunctions 
{
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	CommonFunctions cf = new CommonFunctions();
	
	public JSONArray getNonAssociatedHubsDetails(int clientId, int systemId, String groupId,String zone) 
	{
		
		JSONArray jsonArray = new JSONArray();
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(cf.replaceZone(DemoCarStatements.GET_NON_ASSOCIATED_HUBS,zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setString(5, groupId);
				
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("HubIdDataIndex", rs.getString("HUBID"));
				obj1.put("HubNameDataIndex",rs.getString("NAME"));
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
	
	public JSONArray getAssociatedHubsDetails(int clientId, int systemId, String groupId,String zone) 
	{
		JSONArray jsonArray = new JSONArray();
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
		
			pstmt = con.prepareStatement(cf.replaceZone(DemoCarStatements.GET_ASSOCIATED_HUBS,zone));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, groupId);
				
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("HubIdDataIndex", rs.getString("HUB_ID"));
				obj1.put("HubNameDataIndex",rs.getString("NAME"));
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
	
	public String associateHubs(String associateHubs, String globalClientId,String assetGroup, String systemid, int userId) 
	{
		String message = "";
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pmst = null;
	
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
			
			String[] hubs = associateHubs.split(",");
			
			for(int i=0;i<hubs.length;i++)
			{
				pmst = con.prepareStatement(DemoCarStatements.INSERT_INTO_ASSET_GROUP_HUB_ASSOCIATION);
				pmst.setString(1, systemid);
				pmst.setString(2, globalClientId);
				pmst.setString(3, assetGroup);
				pmst.setString(4, hubs[i]);
				pmst.setInt(5, userId);

				pmst.executeUpdate();
			}
			
			message="Associated successfully";

		} 
		catch (Exception e) 
		{
			System.out.println("Error while associating hubs::"+ e.toString());
			e.printStackTrace();
		} 
		finally 
		{
			jc.releaseConnectionToDB(con, pmst, null);
		}

		return message;
	}
	public String disassociateHubs(String dissassociateHubs, String globalClientId,String assetGroup, String systemid, int userId) 
	{
		String message = "";
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pmst = null;

		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
			
			String[] hubs = dissassociateHubs.split(",");
			
			for(int i=0;i<hubs.length;i++)
			{
				pmst = con.prepareStatement(DemoCarStatements.DELETE_FROM_ASSET_GROUP_HUB_ASSOCIATION);
				pmst.setString(1, systemid);
				pmst.setString(2, globalClientId);
				pmst.setString(3, assetGroup);
				pmst.setString(4, hubs[i]);
				pmst.executeUpdate();
			}
			
			message="DisAssociated successfully";

		} 
		catch (Exception e) 
		{
			System.out.println("Error while associating hubs::"+ e.toString());
			e.printStackTrace();
		} 
		finally 
		{
			jc.releaseConnectionToDB(con, pmst, null);
		}

		return message;
	}

	public ArrayList<Object>  getAssetUtilityData(int clientId, int systemId,String groupId,String date,int offset,String language,int userId) 
	{
		 ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		 ArrayList<String> headersList = new ArrayList<String>();
		 ReportHelper finalreporthelper = new ReportHelper();
		 ArrayList<Object> finlist = new ArrayList<Object>();
		 
		 headersList.add(cf.getLabelFromDB("SLNO",language));
		 headersList.add(cf.getLabelFromDB("Group_Name",language));
		 headersList.add(cf.getLabelFromDB("Registration_No",language));
		 headersList.add(cf.getLabelFromDB("Travel_Time",language));
		 headersList.add(cf.getLabelFromDB("Distance_Travelled",language));
		 headersList.add(cf.getLabelFromDB("Outside_Parking",language));
		 headersList.add(cf.getLabelFromDB("Inside_Parking",language));
		 headersList.add(cf.getLabelFromDB("Percentage",language));
	
		 
		JSONArray jsonArray = new JSONArray();
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
			
			date=date.replaceAll("T", " ");
			
			String Query=DemoCarStatements.GET_DAILY_ASSET_UTILIZATION_DATA;
			
			if(groupId !=null && !groupId.equals("") && !groupId.equals("0"))
			{
				Query=Query+" and a.GROUP_ID = "+groupId;
			}
			pstmt = con.prepareStatement(Query);
			pstmt.setInt(1, offset);
			pstmt.setString(2, date);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5,userId);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				 JSONObject obj1 = new JSONObject();
				 ArrayList<String> informationList=new ArrayList<String>();
				 ReportHelper reporthelper=new ReportHelper();
				 count++;
				 
				 informationList.add(Integer.toString(count));
				 obj1.put("slnoIndex", Integer.toString(count));
				 
				 informationList.add(rs.getString("GROUP_NAME"));
				 obj1.put("groupIndex", rs.getString("GROUP_NAME"));
				 
				 informationList.add(rs.getString("REGISTRATION_NUMBER"));
				 obj1.put("registrationIndex",rs.getString("REGISTRATION_NUMBER"));
				 
				 informationList.add(cf.getHHMMTimeFormat(rs.getDouble("TRAVEL_TIME")));
				 obj1.put("travelTimeIndex",cf.getHHMMTimeFormat(rs.getDouble("TRAVEL_TIME")));
				 
				 informationList.add(rs.getString("DISTANCE_TRAVELLED"));
				 obj1.put("distanceTravelledIndex",rs.getString("DISTANCE_TRAVELLED"));
				 
				 informationList.add(cf.convertMinutesToHHMMFormat(rs.getInt("OUTSIDE_HUB")));
				 obj1.put("outsideParkingIndex",cf.convertMinutesToHHMMFormat(rs.getInt("OUTSIDE_HUB")));
				 
				 informationList.add(cf.convertMinutesToHHMMFormat(rs.getInt("INSIDE_HUB")));
				 obj1.put("insideParkingIndex",cf.convertMinutesToHHMMFormat(rs.getInt("INSIDE_HUB")));
				 
				 informationList.add(rs.getString("PERCENTAGE"));
				 obj1.put("percentageIndex",rs.getString("PERCENTAGE"));

				 jsonArray.put(obj1);
				 reporthelper.setInformationList(informationList);  
				 reportsList.add(reporthelper);
			}
			finlist.add(jsonArray);
		    finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			jc.releaseConnectionToDB(con, pstmt, rs);
		}
	    
		return finlist;
	}
	public ArrayList getMonthlyAssetUtilityData(int clientId, int systemId,String groupId,String startDate,String endDate,int offset,String language,int userId) 
	{
		JSONArray jsonArray = new JSONArray();
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AssetUtilizationBean aub = new AssetUtilizationBean();
		HashMap<String,AssetUtilizationBean> hm = new HashMap<String,AssetUtilizationBean>();
		DecimalFormat formatter = new DecimalFormat("#0.00");
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> finlist = new ArrayList<Object>();
		
		headersList.add(cf.getLabelFromDB("SLNO",language));
		headersList.add(cf.getLabelFromDB("Group_Name",language));
		headersList.add(cf.getLabelFromDB("Registration_No",language));
		headersList.add(cf.getLabelFromDB("Distance_Travelled",language));
		headersList.add(cf.getLabelFromDB("Actual_Working_Days",language));
		headersList.add(cf.getLabelFromDB("Holiday",language));
		headersList.add(cf.getLabelFromDB("Vehicle_Utilized",language));
		headersList.add(cf.getLabelFromDB("Percentage",language));
		headersList.add(cf.getLabelFromDB("Non_Utilized_Days",language));
		headersList.add(cf.getLabelFromDB("Utilized_On_Holidays",language));

		
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
			
			startDate=startDate.replaceAll("T", " ");
			endDate=endDate.replaceAll("T", " ");
			
			String Query1=DemoCarStatements.GET_HOLIDAY;
			
			String Query2=DemoCarStatements.GET_ASSET_UTILIZED_ON_WORKING_DAYS;
			
			String Query3=DemoCarStatements.GET_ASSET_UTILIZED_ON_HOLIDAYS;
			
			String Query4=DemoCarStatements.GET_MONTHLY_ASSET_UTILIZATION;
			
			if(!groupId.equals("0"))
			{
				Query1=Query1+" and GROUP_ID="+groupId;
			}
			Query1=Query1+" group by REGISTRATION_NUMBER";
			
			pstmt = con.prepareStatement(Query1);
			pstmt.setInt(1,offset);
			pstmt.setString(2,startDate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,endDate);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6,clientId);
			pstmt.setInt(7,userId);
			
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				if(hm.get(rs.getString("REGISTRATION_NUMBER")) !=null)
				{
					aub =hm.get(rs.getString("REGISTRATION_NUMBER"));
					aub.setHolidays(rs.getInt("HOLIDAY"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
				else
				{
					aub =new AssetUtilizationBean();
					aub.setHolidays(rs.getInt("HOLIDAY"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
			}
			
			pstmt=null;
			rs=null;
			
			if(!groupId.equals("0"))
			{
				Query2=Query2+" and GROUP_ID="+groupId;
			}
			Query2=Query2+" group by REGISTRATION_NUMBER";
			
			pstmt = con.prepareStatement(Query2);
			pstmt.setInt(1,offset);
			pstmt.setString(2,startDate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,endDate);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6,clientId);
			pstmt.setInt(7, userId);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				if(hm.get(rs.getString("REGISTRATION_NUMBER")) !=null)
				{
					aub =hm.get(rs.getString("REGISTRATION_NUMBER"));
					aub.setUtilizedDaysOnWorking(rs.getInt("vehicleUtilizedInWorkingDays"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
				else
				{
					aub =new AssetUtilizationBean();
					aub.setUtilizedDaysOnWorking(rs.getInt("vehicleUtilizedInWorkingDays"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
			}
			
			pstmt=null;
			rs=null;
			
			if(!groupId.equals("0"))
			{
				Query3=Query3+" and GROUP_ID="+groupId;
			}
			Query3=Query3+" group by REGISTRATION_NUMBER";
			
			pstmt = con.prepareStatement(Query3);
			pstmt.setInt(1,offset);
			pstmt.setString(2,startDate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,endDate);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6,clientId);
			pstmt.setInt(7, userId);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				if(hm.get(rs.getString("REGISTRATION_NUMBER")) !=null)
				{
					aub =hm.get(rs.getString("REGISTRATION_NUMBER"));
					aub.setUtilizedOnHolidays(rs.getInt("vehicleUtilizedInHolidays"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
				else
				{
					aub =new AssetUtilizationBean();
					aub.setUtilizedOnHolidays(rs.getInt("vehicleUtilizedInHolidays"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
			}
			
			pstmt=null;
			rs=null;
			
			if(!groupId.equals("0"))
			{
				Query4=Query4+" and a.GROUP_ID="+groupId;
			}
			Query4=Query4+" group by a.REGISTRATION_NUMBER,b.GROUP_NAME";
			
			pstmt = con.prepareStatement(Query4);
			pstmt.setInt(1,offset);
			pstmt.setString(2,startDate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,endDate);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6,clientId);
			pstmt.setInt(7, userId);

			rs=pstmt.executeQuery();
			int count=0;
			while(rs.next())
			{
				JSONObject obj1 = new JSONObject();
				ArrayList<Object> informationList=new ArrayList<Object>();
				ReportHelper reporthelper=new ReportHelper();
				count++;
				
				aub =hm.get(rs.getString("REGISTRATION_NUMBER"));
				
				informationList.add(Integer.toString(count));
				obj1.put("slnoIndex", Integer.toString(count));
				
				informationList.add( rs.getString("GROUP_NAME"));
				obj1.put("groupIndex", rs.getString("GROUP_NAME"));
				
				informationList.add(rs.getString("REGISTRATION_NUMBER"));
				obj1.put("registrationIndex",rs.getString("REGISTRATION_NUMBER"));
				
				informationList.add(rs.getDouble("DISTANCETRAVELLED"));
				obj1.put("totalDistanceIndex",rs.getDouble("DISTANCETRAVELLED"));
				
				int holidays=0;
				int utilizedOnWorkingDay=0;
				int utilizedOnHoliday=0;
				int actualWorkingDays=0;
				
				if(aub!=null)
				{
					holidays=aub.getHolidays();
					utilizedOnWorkingDay = aub.getUtilizedDaysOnWorking();
					utilizedOnHoliday = aub.getUtilizedOnHolidays();
				}
				
				actualWorkingDays = rs.getInt("SELECTEDDAYS")-holidays;
				
				informationList.add(actualWorkingDays);
				obj1.put("actualWorkingDaysIndex",actualWorkingDays);
				
				informationList.add(holidays);
				obj1.put("holidayIndex",holidays);

				informationList.add(utilizedOnWorkingDay);
				obj1.put("vehicleUtilizedIndex",utilizedOnWorkingDay);
			
				if(actualWorkingDays>0)
				{
					informationList.add(formatter.format(((float)utilizedOnWorkingDay/(float)actualWorkingDays)*100));
					obj1.put("percentageIndex",formatter.format(((float)utilizedOnWorkingDay/(float)actualWorkingDays)*100));
				}
				else
				{
					informationList.add(0.00);
					obj1.put("percentageIndex",0.00);
				}
				
				informationList.add(actualWorkingDays-utilizedOnWorkingDay);
				obj1.put("nonUtilizedDaysIndex",actualWorkingDays-utilizedOnWorkingDay);
				
				informationList.add(utilizedOnHoliday);
				obj1.put("utilizedOnHolidayIndex",utilizedOnHoliday);
				
				jsonArray.put(obj1);
				reporthelper.setInformationList(informationList);  
				reportsList.add(reporthelper);
			}
			finlist.add(jsonArray);
		    finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			jc.releaseConnectionToDB(con, pstmt, rs);
			hm=null;
		}
		finlist.add(jsonArray);
		return finlist;
	}
	

	public ArrayList currentDate(int offset)
	{
		Date startDate = new Date();
		Date endDate = new Date();

		SimpleDateFormat ddmmyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		
		ArrayList datelist = new ArrayList();
		try 
		{
			String today = ddmmyy.format(startDate);
			today = today.substring(0, today.indexOf(" "));
			today = today + " 00:00:00";
			
			cal.setTime(ddmmyy.parse(today));
			cal.add(Calendar.MINUTE, -offset);
			cal.add(Calendar.DATE, -1);
			startDate = cal.getTime();
			
			cal.setTime(ddmmyy.parse(ddmmyy.format(startDate)));
			cal.add(Calendar.HOUR,24);
			endDate = cal.getTime();

			datelist.add(startDate);
			datelist.add(endDate);

		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return datelist;
	}

	public JSONArray getDailyColumnChartData(int clientId, int systemId,String groupId,String date,int offset) 
	{
		JSONArray jsonArray = new JSONArray();
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		date=date.replaceAll("T", " ");
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");

			String Query=DemoCarStatements.GET_TOP10_DAILY_ASSET_UTILIZATION;
	
			if(groupId !=null && !groupId.equals("") && !groupId.equals("0"))
			{
				Query=Query+" and a.GROUP_ID = "+groupId;
			}
			Query=Query+"order by a.PERCENTAGE asc";
			pstmt = con.prepareStatement(Query);
			pstmt.setInt(1, offset);
			pstmt.setString(2, date);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
				
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) 
			{
				obj1 = new JSONObject();
				obj1.put("Xaxis", rs.getString("RegistrationNo"));
				obj1.put("Yaxis",rs.getFloat("Percentage"));
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
	public JSONArray getMonthlyAssetUtilityChartData(int clientId, int systemId,String groupId,String startDate,String endDate,int offset) 
	{
		JSONArray jsonArray = new JSONArray();
		DBConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AssetUtilizationBean aub = new AssetUtilizationBean();
		HashMap<String,AssetUtilizationBean> hm = new HashMap<String,AssetUtilizationBean>();
		DecimalFormat formatter = new DecimalFormat("#0.00");
		HashMap<String,Double> a = new HashMap<String,Double>();
		
		try 
		{
			jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
			
			startDate=startDate.replaceAll("T", " ");
			endDate=endDate.replaceAll("T", " ");
			
			String Query1=DemoCarStatements.GET_HOLIDAY;
			
			String Query2=DemoCarStatements.GET_ASSET_UTILIZED_ON_WORKING_DAYS;
			
			String Query3=DemoCarStatements.GET_MONTHLY_ASSET_UTILIZATION;
			
			if(!groupId.equals("0"))
			{
				Query1=Query1+" and GROUP_ID="+groupId;
			}
			Query1=Query1+" group by REGISTRATION_NUMBER";
			
			pstmt = con.prepareStatement(Query1);
			pstmt.setInt(1,offset);
			pstmt.setString(2,startDate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,endDate);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6,clientId);
			
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				if(hm.get(rs.getString("REGISTRATION_NUMBER")) !=null)
				{
					aub =hm.get(rs.getString("REGISTRATION_NUMBER"));
					aub.setHolidays(rs.getInt("HOLIDAY"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
				else
				{
					aub =new AssetUtilizationBean();
					aub.setHolidays(rs.getInt("HOLIDAY"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
			}
			
			pstmt=null;
			rs=null;
			
			if(!groupId.equals("0"))
			{
				Query2=Query2+" and GROUP_ID="+groupId;
			}
			Query2=Query2+" group by REGISTRATION_NUMBER";
			
			pstmt = con.prepareStatement(Query2);
			pstmt.setInt(1,offset);
			pstmt.setString(2,startDate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,endDate);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6,clientId);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				if(hm.get(rs.getString("REGISTRATION_NUMBER")) !=null)
				{
					aub =hm.get(rs.getString("REGISTRATION_NUMBER"));
					aub.setUtilizedDaysOnWorking(rs.getInt("vehicleUtilizedInWorkingDays"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
				else
				{
					aub =new AssetUtilizationBean();
					aub.setUtilizedDaysOnWorking(rs.getInt("vehicleUtilizedInWorkingDays"));
					hm.put(rs.getString("REGISTRATION_NUMBER"),aub);
				}
			}
			
			pstmt=null;
			rs=null;
			
			if(!groupId.equals("0"))
			{
				Query3=Query3+" and a.GROUP_ID="+groupId;
			}
			Query3=Query3+" group by a.REGISTRATION_NUMBER,b.GROUP_NAME";
			
			pstmt = con.prepareStatement(Query3);
			pstmt.setInt(1,offset);
			pstmt.setString(2,startDate);
			pstmt.setInt(3,offset);
			pstmt.setString(4,endDate);
			pstmt.setInt(5,systemId);
			pstmt.setInt(6,clientId);

			rs=pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();

			while(rs.next())
			{
				aub =hm.get(rs.getString("REGISTRATION_NUMBER"));
				
				int holidays=0;
				int utilizedOnWorkingDay=0;
				int actualWorkingDays=0;
				
				if(aub!=null)
				{
					holidays=aub.getHolidays();
					utilizedOnWorkingDay = aub.getUtilizedDaysOnWorking();
				}
				actualWorkingDays = rs.getInt("SELECTEDDAYS")-holidays;
				
				String percentage="0.00";
				
				if(actualWorkingDays>0)
				{
					percentage=formatter.format(((float)utilizedOnWorkingDay/(float)actualWorkingDays)*100);
				}
				
				a.put(rs.getString("REGISTRATION_NUMBER")+"("+rs.getString("GROUP_NAME")+")",Double.parseDouble(percentage));
				
			}
			LinkedHashMap<String,Double> l = new LinkedHashMap<String,Double>();
			if(a.size() > 0)
			{
				l = sortHashMapByValuesD(a);
			}
			
			Set s = l.keySet();
			Iterator i = s.iterator();
			int count=1;
			while(i.hasNext())
			{
				if(count<=10)
				{
					obj1 = new JSONObject();
					String reg = (String) i.next();
					double percentage = l.get(reg);
					obj1.put("Xaxis",reg);
					obj1.put("Yaxis",percentage);
					jsonArray.put(obj1);
					count++;
				}
				else
				{
					break;
				}
			}
			
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			jc.releaseConnectionToDB(con, pstmt, rs);
			hm=null;
		}
		return jsonArray;
	}
	public LinkedHashMap<String,Double> sortHashMapByValuesD(HashMap<String,Double> passedMap) 
	{
	   List mapKeys = new ArrayList(passedMap.keySet());
	   List<Double> mapValues = new ArrayList(passedMap.values());
	   Collections.sort(mapValues);
	   Collections.sort(mapKeys);

	   LinkedHashMap<String,Double> sortedMap =  new LinkedHashMap<String,Double>();

	   Iterator valueIt = mapValues.iterator();
	   while (valueIt.hasNext()) 
	   {
	       Object val = valueIt.next();
	       Iterator keyIt = mapKeys.iterator();

	       while (keyIt.hasNext()) 
	       {
		        Object key = keyIt.next();
		        Double comp1 = passedMap.get(key);
		        Double comp2 = (Double)val;

		        if (comp1==comp2)
		        {
		            passedMap.remove(key);
		            mapKeys.remove(key);
		            sortedMap.put((String)key, (Double)val);
		            break;
		        }
	       }

	   }
	   return sortedMap;
	}
	
	
	public JSONArray getAssetNumberList(int systemId,String customerId ,int userId) {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DemoCarStatements.Get_ASSET_NUMBER_LIST);
			pstmt.setInt(1,systemId);
			pstmt.setString(2,customerId);
			pstmt.setInt(3,userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("Registration_no", rs.getString("ASSET_NUMBER"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	
	public String checkForValidation(int custId, String regNo, String comandType,int systemId, int userId,boolean doorStatus,boolean keyHolderStatus,String commandMode) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		String message = null;
		KLERequestBean requestDetails = new KLERequestBean();
		
		boolean isCommunicating = false;
		boolean isKeyInserted = false;
		boolean isDoorClosed = false;
		String cmdMode=null;
		System.out.println("Inside .............");

		String deviceId = "";
		String gmtDate = null;

		String systemDate = null;
		int clientId = 0;
		float speed=0;
	try {

			conn=DBConnection.getConnectionToDB("AMS");
			pstmt = conn.prepareStatement(DemoCarStatements.GET_VEHICLE_DETAILS);
			pstmt.setString(1, regNo);

			rs = pstmt.executeQuery();

			if (rs.next()) {

				deviceId = rs.getString("UNIT_NO");
				gmtDate = rs.getString("GMT");
				requestDetails.setIO3(rs.getString("IO3"));
				requestDetails.setIO4(rs.getString("IO4"));
				requestDetails.setIO5(rs.getString("IO5"));
				requestDetails.setIO6(rs.getString("IO6"));
				requestDetails.setIO7(rs.getString("IO7"));
				systemDate = rs.getString("TodayDate");
				requestDetails.setSystemId(rs.getInt("System_id"));
				requestDetails.setClientId(rs.getInt("CLIENTID"));
				requestDetails.setGpsDatetime(rs.getString("GPS_DATETIME"));
				requestDetails.setLocation(rs.getString("LOCATION"));
				requestDetails.setMobileNo("91"+rs.getString("MOBILE_NUMBER"));
				speed=rs.getFloat("SPEED");
				
			}
			if(commandMode.equalsIgnoreCase("SMS")){
			    cmdMode="APP_SMS";
			}else{
			    cmdMode="APP_GPRS";
			}
			isCommunicating = checkForCommunicating(gmtDate, systemDate);
			
			//For Lock Unlock remove non-communicating condition
			if (isCommunicating || commandMode.equalsIgnoreCase("SMS")|| (comandType.equals("LOCK") || comandType.equals("UNLOCK"))) {
				
					if (comandType.equals("LOCK") || comandType.equals("UNLOCK")) {
							message = checkStatusForLockUnlock(isKeyInserted,isDoorClosed, conn, requestDetails, regNo,deviceId, comandType,keyHolderStatus,doorStatus,commandMode);
					
					} else if (comandType.equals("MOBILIZE")) {
							message = checkStatus(conn, regNo, deviceId, requestDetails, comandType,commandMode);
					} else if (comandType.equals("IMMOBILIZE")) {
							//For Horn and Blinker
							String outputNo = getOutputIDforOP(regNo,conn,144);
							
							if(outputNo.equalsIgnoreCase("OP2"))
							{
								addDetails(regNo, 26, 0, "SET", "1", "HB",	conn,"SET",requestDetails.getMobileNo());
							}								
							
							if(speed<5){
								message = checkStatus(conn, regNo, deviceId, requestDetails, comandType,commandMode);
							}else{
								insertInDataRequest(regNo, deviceId, comandType,systemId, requestDetails.getClientId(), conn, "202",requestDetails.getLocation(),requestDetails.getGpsDatetime(),commandMode);
								message = "Request accepted.We will execute when speed is less than 5";
							}
					}else if(comandType.equalsIgnoreCase("HORN/BLINKER OFF")){
						String outputNo = getOutputIDforOP(regNo,conn,144);
						if(outputNo.equalsIgnoreCase("OP2")){
							addDetails(regNo, 26, 0, "SET", "0", "HB",	conn,"SET",requestDetails.getMobileNo());
							message = "Operation executed successfully";
						}else{
							message = "Please enable this feature in Asset tab";
						}
						
					}
			} else {
				insertInDataRequest(regNo, deviceId,comandType, systemId, requestDetails.getClientId(), conn, "2",requestDetails.getLocation(),requestDetails.getGpsDatetime(),commandMode);
				message ="Vehicle Is Not Communicating";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conn, pstmt, rs);
		}
		return message;
	}
	
	
	
	
	public String checkStatusForLockUnlock(boolean isKeyInserted,
			boolean isDoorClosed, Connection conn, KLERequestBean requestDetails,
			String regNo, String deviceId,
			String comandType,boolean doorStatus,boolean keyHolderStatus,String commandMode) {

		String message = null;
		//String cmdMode=null;
		String IO3 = requestDetails.getIO3();
		String IO4 = requestDetails.getIO4();
		String IO5 = requestDetails.getIO5();
		String IO6 = requestDetails.getIO6();
		String IO7 = requestDetails.getIO7();
		int systemId = requestDetails.getSystemId();
		int clientId = requestDetails.getClientId();
		String location = requestDetails.getLocation();
		String gpsdatetime = requestDetails.getGpsDatetime();
		String mobileNo=requestDetails.getMobileNo();
		
		/*if(commandMode.equalsIgnoreCase("SMS")){
			cmdMode="APP_SMS";
		}else{
			cmdMode="APP_GPRS";
		}*/
		/*	Checking Key is in Key Holder or Not.*/
		if(keyHolderStatus){
			isKeyInserted = checkKeyPosition(regNo, conn, "125",IO3, IO4, IO5, IO6, IO7);
		}else{
			isKeyInserted = true;
		}
		if (isKeyInserted) {
			
			String vehicleModel = getVehicleModle(regNo,conn);
			if(!vehicleModel.equals("1142"))
			{
				// Door Status - 38
//				isDoorClosed = checkDoorStatus(regNo, conn, "38",IO3, IO4, IO5, IO6, IO7);
				if(doorStatus){
					isDoorClosed = isDoorClosed(regNo, conn);
				}else{
					isDoorClosed = true;
				}
				if (isDoorClosed) {

					System.out.println("Called...");

					message = processOTADataLockUnlock(regNo,comandType, conn,commandMode,mobileNo);
					if (message.equalsIgnoreCase("Operation Executed Successfully")) {
						insertInDataRequest(regNo, deviceId,comandType, systemId, clientId, conn, "5",location,gpsdatetime,commandMode);
						message = "Operation Executed Successfully";
					} else {
						insertInDataRequest(regNo, deviceId,comandType, systemId, clientId, conn, "6",location,gpsdatetime,commandMode);
						message = "Please Try Again.";
					}

				} else {
					insertInDataRequest(regNo, deviceId,comandType, systemId, clientId, conn, "4",location,gpsdatetime,commandMode);
					message = "Please close the door";
				}
			}
		} else {
			insertInDataRequest(regNo, deviceId, comandType,systemId, clientId, conn, "3",location,gpsdatetime,commandMode);
			message = "Key Not Placed in Key Holder";
		}

		return message;

	}
	
	

	public static boolean checkDoorStatus(String regNo, Connection conn,
			String doorId, String IO3, String IO4, String IO5, String IO6,
			String IO7) {
		String value = "1";
		boolean doorOpen = false;
		value = checkForIOStatus(regNo, conn, doorId, IO3, IO4, IO5, IO6, IO7);
		// TODO change value to 0
		if (value.equalsIgnoreCase("1"))
			doorOpen = false;
		else
			doorOpen = true;
		return doorOpen;
	}
	
	
	private static boolean isDoorClosed(String regNo, Connection conn) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean isDoorClosed = false; 
		try {
			pstmt = conn.prepareStatement(DemoCarStatements.CHECK_DOOR_STATUS_EVENT);

			pstmt.setString(1, regNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				isDoorClosed = rs.getString("EVENT_NUMBER").equals("30")?true:false;
			}
			pstmt.close();
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return isDoorClosed;
	}

	public static boolean checkKeyPosition(String regNo, Connection conn,
			String keyId, String IO3, String IO4, String IO5, String IO6,
			String IO7) {
		String value = "";
		boolean keyPlaced = false;
		value = checkForIOStatus(regNo, conn, keyId, IO3, IO4, IO5, IO6, IO7);
		// TODO change value to 0
		if (value.equalsIgnoreCase("1"))
			keyPlaced = true;
		else
			keyPlaced = false;
		return keyPlaced;
	}
	
	public static String checkForIOStatus(String regNo, Connection conn,
			String id, String IO3, String IO4, String IO5, String IO6,
			String IO7) {

		String IONO = "";
		String ioValue = "0";
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {

			pstmt = conn
					.prepareStatement(DemoCarStatements.GET_IO_ASSOCIATED_WITH_VEHICLE);

			pstmt.setString(1, regNo);
			pstmt.setString(2, id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				IONO = rs.getString("IONO");
			}

			if (IONO.equals("IO3")) {
				ioValue = IO3;
			} else if (IONO.equals("IO4")) {
				ioValue = IO4;
			} else if (IONO.equals("IO5")) {
				ioValue = IO5;
			} else if (IONO.equals("IO6")) {
				ioValue = IO6;
			} else if (IONO.equals("IO7")) {
				ioValue = IO7;
			} else if (IONO.equals("") || IONO.equals(null)) {
				ioValue = "0";
			}

			pstmt.close();
			rs.close();

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return ioValue;

	}
	
	public String processOTADataLockUnlock(String regNo, String commandType,
			Connection conn,String commandMode,String mobileNo) {

		String registrationNo = regNo;
		String command = commandType;

		String response = "";

		if (command.equalsIgnoreCase("LOCK")) {

			response = addDetails(registrationNo, 26, 0, "SET", "1", "LOCK",conn,commandMode,mobileNo);

		} else if (command.equalsIgnoreCase("UNLOCK")) {

			response = addDetails(registrationNo, 26, 0, "SET", "0", "UNLOCK",conn,commandMode,mobileNo);

		}

		try {
		} catch (Exception e) {
			e.printStackTrace();
		}
		return response;
	}
	
	
	
	
private String getVehicleModle(String regNo,Connection conn) {
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String model ="";
		
		try{
			pstmt = conn.prepareStatement(DemoCarStatements.CHECK_VEHICLE_MODEL);
			pstmt.setString(1, regNo);
			rs = pstmt.executeQuery();
			if(rs.next())
				model = rs.getString("Model");		
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		return model;
	}
	
	
	
	
public static boolean checkForCommunicating(String deviceDate,
		String SystemDate) {
	boolean communicating = false;

	SimpleDateFormat format = new SimpleDateFormat(
			"yyyy-mm-dd HH:mm:ss.SSSSSS");
	java.util.Date d1 = null;
	java.util.Date d2 = null;
	try {
		d1 = format.parse(deviceDate);
		d2 = format.parse(SystemDate);
	} catch (ParseException e) {
		e.printStackTrace();
	}

	long diff = d2.getTime() - d1.getTime();
	long diffSeconds = diff / 1000 % 60;
	long diffMinutes = diff / (60 * 1000) % 60;
	long diffHours = diff / (60 * 60 * 1000);

	long minsConvert = (diffHours * 60) + diffMinutes;

	if (minsConvert > 15 || minsConvert < 0) {
		communicating = false;
	} else {
		communicating = true;
	}

	return communicating;

}
	

	
	
	
	
	

	
	
	public static String addDetails(String regNo, int ids, int value,
			String option, String param, String packettype, Connection con,String commandMode,String mobileNo) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int packetNo = 0;
		String unitNo = "0";
		String unitTypeCode = "0";
		int inserted = 0,unitType=0;
		String resmsg = "";

		try {
			//String ipAddress = Inet4Address.getLocalHost().getHostAddress();
			String ipAddress = "104.211.222.164";
			pstmt = con.prepareStatement(DemoCarStatements.GET_UNIT_NO);
			pstmt.setString(1, regNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				unitNo = rs.getString("Unit_Number");
				unitType = rs.getInt("Unit_Type_Code");
				if(unitType == 26 || unitType == 27 || unitType == 32 || unitType == 33 || unitType == 44 ||((!packettype.equalsIgnoreCase("UNLOCK")) && unitType == 68)){ // UnlockCommand is different for CANIQ 
					unitType = 9;
				}else if(unitType == 55 || unitType == 56 || unitType == 59){
					unitType = 54;
				}
			}
			rs.close();
			pstmt.close();
			
			unitTypeCode=unitType+"";
			pstmt = con.prepareStatement(DemoCarStatements.GET_MAX_PACKET_NO);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("PACKET_NO") != null) {
					packetNo = rs.getInt("PACKET_NO");
				}
			}
			rs.close();
			pstmt.close();

			pstmt = con.prepareStatement(DemoCarStatements.MOVE_TO_OTA_HISTORY);
			pstmt.setString(1, unitNo);
			pstmt.setString(2, packettype);
			pstmt.setString(3, unitTypeCode);
			pstmt.executeUpdate();

			pstmt = con.prepareStatement(DemoCarStatements.DELETE_OTA_DETAILS);
			pstmt.setString(1, unitNo);
			pstmt.setString(2, packettype);
			pstmt.setString(3, unitTypeCode);
			pstmt.executeUpdate();
            
			if(commandMode.equalsIgnoreCase("GPRS"))
			{
				commandMode="SET";
		    }
			pstmt = con.prepareStatement(DemoCarStatements.INSERT_OTA_DETAILS);
			pstmt.setInt(1, packetNo);
			pstmt.setString(2, unitNo);
			pstmt.setString(3, packettype);
			pstmt.setString(4, commandMode);
			pstmt.setString(5, param);
			pstmt.setString(6, "N");
			pstmt.setInt(7, Integer.parseInt(unitTypeCode));			
			pstmt.setString(8, ipAddress);
			pstmt.setString(9, mobileNo);

			inserted = pstmt.executeUpdate();

			rs.close();
			pstmt.close();

			if (inserted > 0) {
				resmsg = "Operation Executed Successfully";
			} else {
				resmsg = "Error in Executing Operation Try Again.";
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return resmsg;
	}
	
	//Immobilize Mobilize SMS Fallback Changes
	//Author:-Jithen
	//Adding command mode to be inserted in db to identify mode
	public String processOTAData(String regNo, String commandType,
			Connection conn,String mobileNo,String commandMode) {
	
		String registrationNo = regNo;
		String command = commandType;
		String response = "",outputNo="";
		
		if (command.equalsIgnoreCase("IMMOBILIZE")) {
			outputNo = getOutputIDforOP(regNo,conn,134);
			if(outputNo.equalsIgnoreCase("")){
				outputNo = "IO3";
			}
			response = addDetails(registrationNo, 26, 0, "SET", "1", outputNo,	conn,commandMode,mobileNo);

		} else if (command.equalsIgnoreCase("MOBILIZE")) {
			outputNo = getOutputIDforOP(regNo,conn,134);
			if(outputNo.equalsIgnoreCase("")){
				outputNo = "IO3";
			}
			response = addDetails(registrationNo, 26, 0, "SET", "0", outputNo,	conn,commandMode,mobileNo);

		}
		try {
		} catch (Exception e) {
			e.printStackTrace();
		}
		return response;
	}
	
	public String getOutputIDforOP(String regNo, Connection conn,int alertId) {

//		JDBCConnection jc = null;
//		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ids="",OutputNo="";
		
		try {
//			jc = new JDBCConnection();
//			con = jc.getConnection("sqlserver");
			String stmt = "select OPNO from dbo.VEHICLEOPASSOCIATION where VEHICLEID = ? and len(OPNO)>2 and ALERTID = ? order by OPNO asc";

//			stmt = DeviceConfigSQLStatement.GET_OUTPUT_NO_ASSOCIATED_FOR_IMMOBILIZER;
			pstmt = conn.prepareStatement(stmt);
			pstmt.setString(1, regNo);
			pstmt.setInt(2,alertId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				OutputNo = rs.getString("OPNO");
			}
			if(OutputNo.equals("OP1")){
				OutputNo = "IO3";
			}
			
		} catch (Exception e) {
			System.out.println("error  from getOutputIDforOP..." + e);
		} finally {
//			sqlfunctions_releaseAll(con, pstmt, rs);
		}
		
		return OutputNo;
	}
	
	//Immobilize Mobilize SMS Fallback Changes
	//Author:-Jithen
	//Changed below method to handle command mode
	public String checkStatus(Connection conn,
			String regNo, String deviceId,
			KLERequestBean requestDetails, String comandType,String commandMode) {

		String message = null;

		int systemId = requestDetails.getSystemId();
		int clientId = requestDetails.getClientId();
		String location = requestDetails.getLocation();
		String gpsdatetime = requestDetails.getGpsDatetime();
		String mobileNo=requestDetails.getMobileNo();
		message = processOTAData(regNo, comandType, conn,mobileNo,commandMode);
		if (message.equalsIgnoreCase("Operation Executed Successfully")) {
			insertInDataRequest(regNo, deviceId, comandType,systemId, clientId, conn, "5",location,gpsdatetime,commandMode);
			message ="Operation Executed Successfully";
		} else {
			insertInDataRequest(regNo, deviceId, comandType,systemId, clientId, conn, "6",location,gpsdatetime,commandMode);
			message = "Please Try Again.";
		}
		return message;

	}
	
	public static String insertInDataRequest(String regNo, String unitNo,
			String requestType, int System_id, int CustoemerId,
			Connection conn, String status,String location,String gpsDatetime,String commandMode) {

		PreparedStatement pstmt = null;
		
		//Immobilize Mobilize SMS Fallback Changes
		//Author:-Jithen
		//Handling command mode to insert in DB
		if(commandMode.equalsIgnoreCase("SMS")){
			commandMode="APP_SMS";
		}else{
			commandMode="APP_GPRS";
		}

		try {

			ResultSet rs1 = null;

			int STATUS = 0;

			pstmt = conn.prepareStatement(DemoCarStatements.GET_STATUS);
			pstmt.setString(1, unitNo);
			pstmt.setString(2, requestType);
			pstmt.setString(3,commandMode );

			rs1 = pstmt.executeQuery();

			if (rs1.next()) {
				STATUS = rs1.getInt("STATUS");
			}

			if (STATUS != 5) {
				pstmt = conn.prepareStatement(DemoCarStatements.INSERT_INTO_KLE);
				pstmt.setString(1, regNo);
				pstmt.setString(2, unitNo);
				pstmt.setString(3, requestType);
				pstmt.setString(4, status);
				pstmt.setString(5, "N");
				pstmt.setInt(6, System_id);
				pstmt.setInt(7, CustoemerId);
				pstmt.setString(8, location);
				pstmt.setString(9, gpsDatetime);
				pstmt.setString(10, commandMode);
				pstmt.executeUpdate();

				conn.close();
				pstmt.close();
			} else if (status.equals("1") || status.equals("2") || status.equals("3") || status.equals("4")) {
				pstmt = conn.prepareStatement(DemoCarStatements.INSERT_INTO_KLE_DATA);
				pstmt.setString(1, regNo);
				pstmt.setString(2, unitNo);
				pstmt.setString(3, requestType);
				pstmt.setString(4, status);
				pstmt.setString(5, "N");
				pstmt.setInt(6, System_id);
				pstmt.setInt(7, CustoemerId);
				pstmt.setString(8, location);
				pstmt.setString(9, gpsDatetime);
				pstmt.setString(10, commandMode);
				pstmt.executeUpdate();

				conn.close();
				pstmt.close();
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return status;
	}

	
	public ArrayList<Object> getKLERequestReport(int customerid,int systemId,int offset,String startDate,String endDate,String pageName) {
		JSONArray KLEJsonArray = new JSONArray();
		JSONObject KLEJsonObject = new JSONObject();
		ArrayList<String> KLERequestHeadersList = new ArrayList<String>();
		ArrayList<ReportHelper> KLERequestReportsList = new ArrayList<ReportHelper>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> KLERequestFinalList = new ArrayList<Object>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		
		String regNo = "";
		String unitNo = "";
		String gpsDate = "";
		String location = "";
		String insertedTime = "";
		String commandType = "";
		int status= 0;
		String gridStatus = null;
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		KLERequestHeadersList.add("SLNO");
		KLERequestHeadersList.add("Asset Number");
		KLERequestHeadersList.add("Unit Number");
		KLERequestHeadersList.add("Command Type");
		KLERequestHeadersList.add("DateTime");
		KLERequestHeadersList.add("Location");
		KLERequestHeadersList.add("Action Time");
		KLERequestHeadersList.add("Status");
		KLERequestHeadersList.add("Request Id");
		if(pageName.equals("VehicleMobilizeManagement")){
		KLERequestHeadersList.add("Response Time");
		}
		try {		
			KLEJsonArray = new JSONArray();
			KLEJsonObject = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			if(pageName.equals("VehicleMobilizeManagement"))
			{
				pstmt = con.prepareStatement(DemoCarStatements.GET_KLE_REQUEST_REPORT.replace("#", " and REQUEST_TYPE in ('MOBILIZE','IMMOBILIZE') ").replace("$", " and REQUEST_TYPE in ('MOBILIZE','IMMOBILIZE') "));	
			} else if(pageName.equals("KLERequest")){
				pstmt = con.prepareStatement(DemoCarStatements.GET_KLE_REQUEST_REPORT.replace("#", " and REQUEST_TYPE in ('LOCK','UNLOCK') ").replace("$", " and REQUEST_TYPE in ('LOCK','UNLOCK') "));	
			}
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerid);
			pstmt.setInt(5,offset);
			pstmt.setString(6, startDate);
			pstmt.setInt(7,offset);
			pstmt.setString(8, endDate);
			pstmt.setInt(9,offset);
			pstmt.setInt(10,offset);
			pstmt.setInt(11, systemId);
			pstmt.setInt(12, customerid);
			pstmt.setInt(13,offset);
			pstmt.setString(14, startDate);
			pstmt.setInt(15,offset);
			pstmt.setString(16, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {	
				ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				KLEJsonObject = new JSONObject();
				count++;
				regNo = rs.getString("REGISTRATION_NO");
				unitNo = rs.getString("UNIT_NUMBER");
				location=rs.getString("LOCATION");
				status = rs.getInt("STATUS");
				commandType = rs.getString("REQUEST_TYPE");
				if(status == 1)
				{
					gridStatus = "VEHICLE NOT REGISTERED";
				}else if(status == 2){
					gridStatus = "VEHICLE NOT COMMINICATING";
				}else if(status == 3){
					gridStatus = "KEY NOT INSERTED";
				}else if(status == 4){
					gridStatus = "DOOR NOT CLOSED";
				}else if(status == 5 || status == 202){    // 202 => current speed>=5 and device will be immobilized when speed<5
					gridStatus = "IN PROCESS";
				}else if(status == 7){
					gridStatus = "DUPLICATE REQUEST";
				}else if(status == 200){
					gridStatus = "SUCCESS";
				}else if(status == 302){
					gridStatus = "SUCCESS";
				}else if(status == 404){
					gridStatus = "DISCARDED";
				}else if(status == 414){
					gridStatus = "TAMPER";					
				}else{
					gridStatus = "UNKNOWN";
				}
				
				KLEJsonObject.put("slnoIndex",Integer.toString(count));
				informationList.add(Integer.toString(count));
				
				KLEJsonObject.put("registrationNoDataIndex", regNo);
				informationList.add(regNo);
				
				KLEJsonObject.put("unitNoDataIndex", unitNo);
				informationList.add(unitNo);
				
				KLEJsonObject.put("commandTypeDataIndex",commandType);
				informationList.add(commandType);
				
				 if (rs.getString("GPS_DATETIME") == null || rs.getString("GPS_DATETIME").equals("") || rs.getString("GPS_DATETIME").contains("1900")) {
					     KLEJsonObject.put("GPSDataIndex", "");
					     informationList.add("");
					 } else {
						 KLEJsonObject.put("GPSDataIndex",ddMMyyyyHHmmss.format(rs.getTimestamp("GPS_DATETIME")));
						 informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("GPS_DATETIME")));
					 }

				KLEJsonObject.put("locationDataIndex", location);
				informationList.add(location);
				
				KLEJsonObject.put("insertedTimeDataIndex", ddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_TIME")));
				informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("INSERTED_TIME")));
				
				KLEJsonObject.put("statusDataIndex",gridStatus);
				informationList.add(gridStatus);
				
				KLEJsonObject.put("requestidDataIndex",rs.getString("REQUEST_ID"));
				informationList.add(rs.getString("REQUEST_ID"));
				
				if(pageName.equals("VehicleMobilizeManagement")){
				if (rs.getString("RESPONSE_SENT_TIME") == null || rs.getString("RESPONSE_SENT_TIME").equals("") || rs.getString("RESPONSE_SENT_TIME").contains("1900")) {
				     KLEJsonObject.put("responseTimeDataIndex", "");
				     informationList.add("");
				 } else {
				KLEJsonObject.put("responseTimeDataIndex", ddMMyyyyHHmmss.format(rs.getTimestamp("RESPONSE_SENT_TIME")));
				informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("RESPONSE_SENT_TIME")));
				 }
				}
				KLEJsonArray.put(KLEJsonObject);
				reporthelper.setInformationList(informationList);
				KLERequestReportsList.add(reporthelper);
				}
			KLERequestFinalList.add(KLEJsonArray);
			finalreporthelper.setReportsList(KLERequestReportsList);
			finalreporthelper.setHeadersList(KLERequestHeadersList);
			KLERequestFinalList.add(finalreporthelper);
		
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in Admin Functions:- getKERequestReport "+e.toString());
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return KLERequestFinalList;
		
	
	}
	
	public JSONArray getDriverTripDetails(int customerid, int systemId,String zone) {
		SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(DemoCarStatements.GET_DRIVER_TRIP_DETAILS.replace("LOCATION", "LOCATION_ZONE_"+zone));
			pstmt.setInt(1, customerid);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {	
				count++;
				String openDate="";
				String closedDate="";
				openDate = simpleDateFormatddMMYY.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("START_DATE")));
				if (openDate.substring(6, 10).equals("1900")){
					openDate = "";
				}
				closedDate = simpleDateFormatddMMYY.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("END_DATE")));
				if (closedDate.substring(6, 10).equals("1900")){
					closedDate = "";
				}
				jsonObject = new JSONObject();
				jsonObject.put("slnoIndex", count);
				jsonObject.put("drivrTripDetuniqueId", rs.getString("UNIQUE_ID"));
				jsonObject.put("assetNoIndex", rs.getString("REGISTRATION_NO"));
				jsonObject.put("tripIdIndex", rs.getString("TRIP_ID"));
				jsonObject.put("driverNameIndex", rs.getString("DRIVER_ID"));
				jsonObject.put("groupNameIndex", rs.getString("GROUP_NAME"));
				jsonObject.put("pickUpLocationIndex", rs.getString("HUB_ID"));
				jsonObject.put("startDateIndex", openDate);
				jsonObject.put("endDateIndex", closedDate);
				jsonObject.put("statusIndex", rs.getString("STATUS"));
				jsonObject.put("createdByIndex", rs.getString("CREATED_BY"));
				jsonObject.put("closedByIndex", rs.getString("CLOSED_BY"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in Admin Functions:- getDriverTripDetails "+e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	
public JSONArray getVehiclesforClient(int systemid, int clientid,
			int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DemoCarStatements.GET_VEHICLE_NO_FOR_DRIVER_TRIP_DETAILS);
			pstmt.setInt(1, clientid);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, systemid);
			pstmt.setInt(5, clientid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("vehicleNo", rs.getString("REGISTRATION_NUMBER"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public String saveDriverTripDetails(String assetNo,
			String startDate,String tripId, int systemId, int createdUser,
			int cutomerId,int hubId) {
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message="Error";
		int update=0;
		try {
			if (startDate.contains("T")) {
				startDate = startDate.replaceAll("T", " ");
				}
				conAdmin = DBConnection.getConnectionToDB("AMS");					
				pstmt=null;
				pstmt = conAdmin.prepareStatement(DemoCarStatements.CHECK_DUPLICATE_TRIP_ID);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, cutomerId);
				pstmt.setString(3, tripId);
				rs = pstmt.executeQuery();
				
				if(! rs.next()){
					pstmt = conAdmin.prepareStatement(DemoCarStatements.INSERT_DRIVER_TRIP_DETAILS);
					pstmt.setString(1, assetNo);
					pstmt.setString(2,"" );
					pstmt.setInt(3, hubId);
					pstmt.setString(4, startDate);
					pstmt.setString(5,tripId );
					pstmt.setInt(6, cutomerId);
					pstmt.setInt(7, systemId);
					pstmt.setInt(8, createdUser);
					pstmt.setString(9, "Open");
					update=pstmt.executeUpdate();
					if(update==1){
						message="Trip Details Saved Successfully,";
					}else{
						message="Error is Adding Asset Group";	
					}
				}else{
					message="Trip Id Already Exists";	
				}
				
		} catch (Exception e) {
				message="Error during Insert";	
			System.out.println("Error in Admin Functions:-saveAssetGroupDetails "+e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return message;
	}
	
public String modifyDriverTripDetails(String uniqueId,String closeDate,int systemId,int 
			closedUser,int cutomerId,String startDate,String assetNo,int offSet) {
		Connection con = null;
		String message="ERROR";
		try {
			if (closeDate.contains("T")) {
				closeDate = closeDate.replaceAll("T", " ");
			}
			if (startDate.contains("T")) {
				startDate = startDate.replaceAll("T", " ");
			}
			con = DBConnection.getConnectionToDB("AMS");
			message = getScoresForTripDetailsAndUpdate(systemId,cutomerId,startDate,closeDate,assetNo,con,offSet,closedUser,Integer.parseInt(uniqueId));
		} catch (Exception e) {
			message="Error during Update";
			System.out.println("Error in Admin Functions:-modifyDriverTripDetails "+e.toString());
			e.printStackTrace();
		} 
		return message;
	} 

public String getScoresForTripDetailsAndUpdate(int systemId,int cutomerId,String startDate,String closeDate,String assetNo,
		Connection con,int offSet,int closedUser,int uniqueId)
{
	HashMap<String,DriverTripDetailBean> driverEval = new HashMap<String, DriverTripDetailBean>();
	String msg = "";
	DecimalFormat df  = new DecimalFormat("#.##");
	SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	ArrayList<Date> dateList = new ArrayList<Date>();
	double distanceTravelled= 0;
	try {
		dateList = getDateArrayForProcessing(yyyyMMdd.parse(startDate),yyyyMMdd.parse(closeDate),offSet);
		double ConversionFactor=cf.initializedistanceConversionFactor(systemId,con,assetNo);
		if (dateList.size()>0) {
			
		}
		int overSpeedCount =getOverSpeedCount(assetNo,systemId,yyyyMMdd.format(dateList.get(0)),yyyyMMdd.format(dateList.get(1)),offSet,con);
		HashMap<String, Double> vehicleAccDeAccAlertList=getHarshAcceDeAcceData(assetNo,systemId,yyyyMMdd.format(dateList.get(0)),yyyyMMdd.format(dateList.get(1)),offSet,con);
		VehicleActivity vi=new VehicleActivity(con, assetNo, dateList.get(0), dateList.get(1), offSet, systemId, cutomerId, 0);
		VehicleSummaryBean vsb = vi.getVehicleSummaryBean();
		if(vsb != null){						
			 distanceTravelled=Double.parseDouble(df.format(vsb.getTotalDistanceTravelled()*ConversionFactor));
		}
		msg = calCulateAndUpdateScoresForVehicle(assetNo,driverEval,systemId,cutomerId,con,closedUser,uniqueId,closeDate,vehicleAccDeAccAlertList,distanceTravelled,overSpeedCount);
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, null, null);
	}
	return msg;
}

/**get alert data for seat belt,overspeed and ac idle */
public int getOverSpeedCount(String vehicleNo,int systemId,String startGPSDate,String endGPSDate,int offset,Connection con){
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	int overSpeedCount = 0;
	try{
		
		pstmt = con.prepareStatement(DemoCarStatements.GET_OVERSPEED_DATA);
		pstmt.setString(1,vehicleNo);
		pstmt.setString(2,startGPSDate);	
		pstmt.setString(3,endGPSDate);	
		pstmt.setInt(4,systemId);	
		pstmt.setString(5,vehicleNo);
		pstmt.setString(6,startGPSDate);	
		pstmt.setString(7,endGPSDate);	
		pstmt.setInt(8,systemId);	
		rs = pstmt.executeQuery();
		if(rs.next()){
			 overSpeedCount = rs.getInt("overSpeedCount");//over speed
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null,pstmt,rs);
	}
	
	return overSpeedCount;
}

public HashMap<String, Double> getHarshAcceDeAcceData(String vehicleNo,int systemId,String startGPSDate,String endGPSDate,int offset,Connection con){
	HashMap<String, Double> alertDataList = new HashMap<String, Double>();
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		pstmt = con.prepareStatement(DemoCarStatements.GET_HARSH_ACC_BRK_DETAILS);
		pstmt.setString(1,vehicleNo);
		pstmt.setString(2,startGPSDate);	
		pstmt.setString(3,endGPSDate);
		pstmt.setInt(4,systemId);	
		pstmt.setString(5,vehicleNo);
		pstmt.setString(6,startGPSDate);	
		pstmt.setString(7,endGPSDate);	
		pstmt.setInt(8,systemId);	
		rs = pstmt.executeQuery();
		while(rs.next()){
			alertDataList.put(rs.getString("AlertName").toUpperCase(),rs.getDouble("harshCount"));//harsh acc,harsh brk,harsh curving
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(null,pstmt,rs);
	}
	
	return alertDataList;
}

public String calCulateAndUpdateScoresForVehicle(String assetNo,HashMap<String,DriverTripDetailBean> driverEval,
		int systemId,int clientId,Connection con,int closedBy,int uniqueId,String closeDate,
		HashMap<String, Double> vehicleAccDeAccAlertList,double distanceTravelled,double overSpeedCount){
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	double distanceScore = 0;
	double overSpeedScore = 0;
	double acclCount = 0;//harsh acceleration
	double acclCountScore = 0;	
	double declCount = 0;//harsh breaking
	double declCountScore = 0;	
	double harshCurveCount = 0;
	double harshCurveScore = 0;
	double totalScore = 0;
	int settingId = 0;
	String message = "";
	try{
		for(Map.Entry<String,Double> entry :vehicleAccDeAccAlertList.entrySet())
		{
			 if(entry.getKey().equals("HARSH ACCELERATION")){ //ACCL
				acclCount = entry.getValue();
			 }else if(entry.getKey().equals("HARSH BRAKING")){ //DECL
				declCount= entry.getValue();
			 }else if(entry.getKey().equals("HARSH CURVING")){
				 harshCurveCount=entry.getValue();
			 }
		}
		
		pstmt=con.prepareStatement(DemoCarStatements.GET_SETTING_ID_FOR_TRIP_DETAIL);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2,clientId);
		rs = pstmt.executeQuery();
		if(rs.next())
		{
			settingId = rs.getInt("score_setting_id");
		}
		ScoreSettings ss  = new ScoreSettings(systemId,settingId,con,clientId);
		
	     distanceScore = ss.getScore1(1, distanceTravelled,distanceTravelled);
		 overSpeedScore = ss.getScore1(3, overSpeedCount,distanceTravelled);
		 acclCountScore = ss.getScore1(5, acclCount,distanceTravelled);	
		 declCountScore = ss.getScore1(6, declCount,distanceTravelled);	
		 harshCurveScore = ss.getScore1(8, harshCurveCount,distanceTravelled);	
		 
		int div=5;
		if( distanceScore==0 ){
			div=div-1;
		} if( overSpeedScore==0 ){
			div=div-1;
		}   if( acclCountScore==0 ){
			div=div-1;
		}	if( declCountScore==0){
			div=div-1;
		}	if( harshCurveScore==0){
			div=div-1;
		}	
		
		totalScore = distanceScore + overSpeedScore+ acclCountScore + declCountScore +harshCurveScore;

		if(div!=0){
			totalScore = (totalScore/div);
		}
		pstmt=con.prepareStatement(DemoCarStatements.UPDATE_DRIVER_TRIP_DETAILS);
		pstmt.setString(1, "Closed");
		pstmt.setInt(2,closedBy );
		pstmt.setString(3,closeDate );
		pstmt.setDouble(4,distanceTravelled);
		pstmt.setDouble(5,distanceScore);
		pstmt.setDouble(6,overSpeedCount);
		pstmt.setDouble(7,overSpeedScore);
		pstmt.setDouble(8,acclCount);
		pstmt.setDouble(9,acclCountScore);
		pstmt.setDouble(10,declCount);
		pstmt.setDouble(11,declCountScore);
		pstmt.setDouble(12,harshCurveCount);
		pstmt.setDouble(13,harshCurveScore);
		pstmt.setDouble(14,totalScore);
		pstmt.setInt(15,settingId);
		pstmt.setInt(16,uniqueId );
		pstmt.setInt(17, clientId);
		pstmt.setInt(18, systemId);
		int result = pstmt.executeUpdate();
		if(result==1){
			message="Trip Closed Successfully";
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}

public double getPerHundradeKm(double count,double distanceDrived){
	if(distanceDrived > 0){
		return (count * 100) / distanceDrived;
	}else {
		return 0;
	}
}

public void updateDriverEvaluationActivity(String start,String end,int systemId,double distanceTravelled,double drivingHr,double speed,
		double stopHrs,double idleHrs,double seatBeltOffDist,double overspeeddist,HashMap<String,DriverTripDetailBean> driverEval,String assetNo){
	DriverTripDetailBean dTD = null;
	String key = assetNo + "||"+ systemId + "||" +start;
	if(driverEval.get(key) == null){
		dTD = new DriverTripDetailBean();
		dTD.setTotalDistance(distanceTravelled);
		dTD.setDrivingHr(drivingHr);
		driverEval.put(key, dTD);
	}else{
		dTD = driverEval.get(key);
		double existingDistance = dTD.getTotalDistance();
		dTD.setTotalDistance(existingDistance + distanceTravelled);
		double existingDrivingHr = dTD.getDrivingHr();
		dTD.setDrivingHr(existingDrivingHr + drivingHr);
		driverEval.put(key, dTD);
	}
					
}

public ArrayList<Date> getDateArrayForProcessing(Date d1,Date d2, int offset) {

	Date startDate = null;
	ArrayList<Date> dateList = new ArrayList<Date>();
	Date endDate = null;
	Calendar cal = Calendar.getInstance();
	try {
		cal.setTime(d1);
		cal.add(Calendar.MINUTE, -offset);
		startDate = cal.getTime();

		cal.setTime(d2);
		cal.add(Calendar.MINUTE, -offset);
		endDate = cal.getTime();
		dateList.add(startDate);
		dateList.add(endDate);
	} catch (Exception e) {
		e.printStackTrace();
	}
	return dateList;
}

public JSONArray getHubNamesForTripDetail(int custId,int systemId,String zone) {
    Connection conAdmin = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();
    JSONObject jsonObject = new JSONObject();
    try {
        conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
        pstmt = conAdmin.prepareStatement(DemoCarStatements.GET_HUB_NAMES_FOR_TRIP_DETAIL.replace("LOCATION", "LOCATION_ZONE_"+zone));
        pstmt.setInt(1, custId);
        pstmt.setInt(2, systemId);
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
public ArrayList<Object> getTripDetailsReport(int ClientId, int systemId,String startDate, String endDate,String zone,String language) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONObject obj = null;
	JSONArray jsonArray = new JSONArray();
	ArrayList<Object> finalist = new ArrayList<Object>();
	ArrayList<String> headersList = new ArrayList<String>();
	ArrayList<ReportHelper> reportList = new ArrayList<ReportHelper>();
	ReportHelper finalReportHelper = new ReportHelper();
	int count = 0;
	DecimalFormat Dformatter = new DecimalFormat("#.##");
	SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	try{
		headersList.add(cf.getLabelFromDB("SLNO", language));
		headersList.add(cf.getLabelFromDB("Registration_Number", language));
		headersList.add(cf.getLabelFromDB("Group_Name", language));
		headersList.add(cf.getLabelFromDB("Driver_Id", language));
		headersList.add(cf.getLabelFromDB("PickUp_Location", language));
		headersList.add(cf.getLabelFromDB("Trip_Id", language));
		headersList.add(cf.getLabelFromDB("Start_Date", language));
		headersList.add(cf.getLabelFromDB("End_Date", language));
		headersList.add(cf.getLabelFromDB("Distance_Driven", language)+"(Kms)");
		headersList.add(cf.getLabelFromDB("Distance_Driven_Score", language));
		headersList.add(cf.getLabelFromDB("Driving_Hours", language)+"(HH:MM)");
		headersList.add(cf.getLabelFromDB("Driving_Hours_Score", language));
		headersList.add(cf.getLabelFromDB("OverSpeed_Count", language));
		headersList.add(cf.getLabelFromDB("OverSpeed_Count_Score", language));
		headersList.add(cf.getLabelFromDB("OverSpeed_Graded_Count", language));
		headersList.add(cf.getLabelFromDB("OverSpeed_Graded_Count_Score", language));
		headersList.add(cf.getLabelFromDB("OverSpeed_Duration_Hrs", language)+"(MM.SS)");
		headersList.add(cf.getLabelFromDB("OverSpeed_Duration_Score", language));
		headersList.add(cf.getLabelFromDB("Idle_Time", language));
		headersList.add(cf.getLabelFromDB("Idle_Time_Score", language));
		headersList.add(cf.getLabelFromDB("Harsh_Acceleration_Count", language));
		headersList.add(cf.getLabelFromDB("Harsh_Acceleration_Score", language));
		headersList.add(cf.getLabelFromDB("Harsh_Breaking_Count", language));
		headersList.add(cf.getLabelFromDB("Harsh_Breaking_Score", language));
		headersList.add(cf.getLabelFromDB("Harsh_Curve_Count", language));
		headersList.add(cf.getLabelFromDB("Harsh_Curve_Score", language));
		headersList.add(cf.getLabelFromDB("Seat_Belt_Count", language));
		headersList.add(cf.getLabelFromDB("Seat_Belt_Score", language));
		headersList.add(cf.getLabelFromDB("Seat_Belt_Distance_Count", language));
		headersList.add(cf.getLabelFromDB("Seat_Belt_Distance_Count_Score", language));
		headersList.add(cf.getLabelFromDB("Continious_Driving_Hrs", language)+"(HH.MM)");
		headersList.add(cf.getLabelFromDB("Continious_Driving_Score", language));
		headersList.add(cf.getLabelFromDB("Total_Score", language));
		headersList.add(cf.getLabelFromDB("Status", language));
		headersList.add(cf.getLabelFromDB("Created_By", language));
		headersList.add(cf.getLabelFromDB("Closed_By", language));
		
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(DemoCarStatements.GET_TRIP_DETAILS_REPORT.replace("LOCATION", "LOCATION_ZONE_"+zone));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, ClientId);
		pstmt.setString(3, startDate.replace("T", " "));
		pstmt.setString(4, endDate.replace("T", " "));
		rs = pstmt.executeQuery();
		while(rs.next()){
			count ++;
			obj = new JSONObject();
			ArrayList<Object> informationList = new ArrayList<Object>();
			ReportHelper reportHelper = new ReportHelper();
			obj.put("SLNODI", count);
			informationList.add(count);
			
			obj.put("registrationNoDI", rs.getString("RegistrationNo"));
			informationList.add(rs.getString("RegistrationNo"));
			
			obj.put("groupNameDI", rs.getString("GroupName"));
			informationList.add(rs.getString("GroupName"));
			
			obj.put("driverIdDI", rs.getString("DriverId"));
			informationList.add(rs.getString("DriverId"));
			
			obj.put("hubIdDI", rs.getString("HubId"));
			informationList.add(rs.getString("HubId"));
			
			obj.put("tripIdDI", rs.getString("TripId"));
			informationList.add(rs.getString("TripId"));
			
			if(rs.getString("StartDate").contains("1900")){
				obj.put("startDateDI", "");
				informationList.add("");
			}else{
				obj.put("startDateDI", rs.getString("StartDate"));
				informationList.add(ddMMyyyyHHmmss.format(yyyyMMdd.parse(rs.getString("StartDate"))));
				
			}if(rs.getString("EndDate").contains("1900")){	
				obj.put("endDateDI", "");
				informationList.add("");
			}else{
				obj.put("endDateDI", rs.getString("EndDate"));
				informationList.add(ddMMyyyyHHmmss.format(yyyyMMdd.parse(rs.getString("EndDate"))));
			}
			
			obj.put("distanceDrivenDI", Dformatter.format(rs.getDouble("DistanceDriven")));
			informationList.add(Dformatter.format(rs.getDouble("DistanceDriven")));
			
			obj.put("distanceDrivenScoreDI", Dformatter.format(rs.getDouble("DistanceDrivenScore")));
			informationList.add(Dformatter.format(rs.getDouble("DistanceDrivenScore")));
			
			if(Dformatter.format(rs.getDouble("DrivingHrs")).contains(".")){
				String ss1=rs.getString("DrivingHrs").substring(0,rs.getString("DrivingHrs").indexOf('.'));
				String ss2=rs.getString("DrivingHrs").substring(rs.getString("DrivingHrs").indexOf('.'), rs.getString("DrivingHrs").length());
				int s=(int)Math.rint((Double.parseDouble(ss2)*60));
				String ss3="";
				if(s<10){
					ss3="0"+String.valueOf(s);
				}else{
					ss3=String.valueOf(s);
				}
				obj.put("drivingHrsDI",ss1+":"+ss3);
				informationList.add(ss1+":"+ss3);
			}else{
				obj.put("drivingHrsDI", rs.getString("DrivingHrs").replace(".", ":"));
				informationList.add(rs.getString("DrivingHrs").replace(".", ":"));
			}
			obj.put("drivingHrsScore", Dformatter.format(rs.getDouble("DrivingHrsScore")));
			informationList.add(Dformatter.format(rs.getDouble("DrivingHrsScore")));
			
			obj.put("overSpeedCountDI", Dformatter.format(rs.getDouble("OverSpeedCount")));
			informationList.add(Dformatter.format(rs.getDouble("OverSpeedCount")));
			
			obj.put("overSpeedCountScoreDI", Dformatter.format(rs.getDouble("OverSpeedCountScore")));
			informationList.add(Dformatter.format(rs.getDouble("OverSpeedCountScore")));
			
			obj.put("overSpeedGradedCountDI", Dformatter.format(rs.getDouble("OverSpeedGradedCount")));
			informationList.add(Dformatter.format(rs.getDouble("OverSpeedGradedCount")));
			
			obj.put("overSpeedGradedCountScoreDI", Dformatter.format(rs.getDouble("OverSpeedGradedCountScore")));
			informationList.add(Dformatter.format(rs.getDouble("OverSpeedGradedCountScore")));
			
			obj.put("overSpeedDurationCountDI", Dformatter.format(00.00));
			informationList.add(0);
			
			obj.put("overSpeedDurationScoreDI", 0);
			informationList.add(0);
			
			obj.put("idleTimeDI", Dformatter.format(rs.getDouble("IdleTime")));
			informationList.add(Dformatter.format(rs.getDouble("IdleTime")));
			
			obj.put("idleTimeScoreDI", Dformatter.format(rs.getDouble("IdleTimeScore")));
			informationList.add(Dformatter.format(rs.getDouble("IdleTimeScore")));
			
			obj.put("harshAccCountDI", Dformatter.format(rs.getDouble("HarshAccCount")));
			informationList.add(Dformatter.format(rs.getDouble("HarshAccCount")));
			
			obj.put("harshAccScoreDI", Dformatter.format(rs.getDouble("HarshAccScore")));
			informationList.add(Dformatter.format(rs.getDouble("HarshAccScore")));
			
			obj.put("harshBrkCountDI", Dformatter.format(rs.getDouble("HarshBrkCount")));
			informationList.add(Dformatter.format(rs.getDouble("HarshBrkCount")));
			
			obj.put("harshBrkScoreDI", Dformatter.format(rs.getDouble("HarshBrkScore")));
			informationList.add(Dformatter.format(rs.getDouble("HarshBrkScore")));
			
			obj.put("harshCurveCountDI", Dformatter.format(rs.getDouble("HarshCurveCount")));
			informationList.add(Dformatter.format(rs.getDouble("HarshCurveCount")));
			
			obj.put("harshCurveScoreDI", Dformatter.format(rs.getDouble("HarshCurveScore")));
			informationList.add(Dformatter.format(rs.getDouble("HarshCurveScore")));
			
			obj.put("seatBeltCountDI", Dformatter.format(rs.getDouble("seatBeltCount")));
			informationList.add(Dformatter.format(rs.getDouble("seatBeltCount")));
			
			obj.put("seatBeltScoreDI", Dformatter.format(rs.getDouble("SeatBeltScore")));
			informationList.add(Dformatter.format(rs.getDouble("SeatBeltScore")));
			
			obj.put("seatBeltDistanceCountDI", Dformatter.format(rs.getDouble("SeatBeltDistanceCount")));
			informationList.add(Dformatter.format(rs.getDouble("SeatBeltDistanceCount")));
			
			obj.put("seatBeltDistanceCountScoreDI", Dformatter.format(rs.getDouble("SeatBeltDistanceScore")));
			informationList.add(Dformatter.format(rs.getDouble("SeatBeltDistanceScore")));
			
			obj.put("continiousDrivingCountDI", Dformatter.format(00.00));
			informationList.add(0);
			
			obj.put("continiousDrivingScoreDI", 0);
			informationList.add(0);
			
			obj.put("totalScoreDI", Dformatter.format(rs.getDouble("TotalScore")));
			informationList.add(Dformatter.format(rs.getDouble("TotalScore")));
			
			obj.put("statusDI", rs.getString("Status"));
			informationList.add(rs.getString("Status"));

			obj.put("createdByDI", rs.getString("CreatedBy"));
			informationList.add(rs.getString("CreatedBy"));
			
			obj.put("closedByDI", rs.getString("ClosedBy"));
			informationList.add(rs.getString("ClosedBy"));
			
			jsonArray.put(obj);
			reportHelper.setInformationList(informationList);
			reportList.add(reportHelper);
		}
		finalReportHelper.setHeadersList(headersList);
		finalReportHelper.setReportsList(reportList);
		finalist.add(jsonArray);
		finalist.add(finalReportHelper);
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return finalist;
} 

public String getSpeed(int custid,int systemid,String regNo) {
	SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"); 
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String message="";

	try {
		con = DBConnection.getConnectionToDB("AMS");

		pstmt = con.prepareStatement(DemoCarStatements.GET_SPEED);
		pstmt.setInt(1, custid);
		pstmt.setInt(2, systemid);
		pstmt.setString(3, regNo);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			message = "Vehicle Speed : "+rs.getString("SPEED")+"Km/Hr, at "+(ddMMyyyyHHmmss.format(rs.getTimestamp("GPS_DATETIME")));
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;
}
	
	
	
}
