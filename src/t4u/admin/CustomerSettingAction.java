package t4u.admin;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
/**
 * 
 * This Class is used to save customersetting details
 *
 */
public class CustomerSettingAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		
		HttpSession session=request.getSession();
		AdminFunctions adfunc=new AdminFunctions();
		CommonFunctions cf=new CommonFunctions();
		
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		String language=loginInfo.getLanguage();
		int userId=loginInfo.getUserId();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		String param = "";
		
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}
		
		if(param.equals("getProcessLabel")){
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custId="0";
				if(request.getParameter("CustId")!=null){
				 custId=request.getParameter("CustId");
				}
			
				jsonArray=adfunc.getProcessLabelIdList(custId,language);
		
				if(jsonArray.length()>0){
					jsonObject.put("ProcessLabelIdRoot", jsonArray);
					}else{
						jsonObject.put("ProcessLabelIdRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
				
			} catch (Exception e) {
				System.out.println("Exception in CustomerSettingAction:-getProcessLabel "+e.toString());
			}
		}
		/****************************************************************************************************************************************************
		 * 													save Essential Monitoring Details
		 *****************************************************************************************************************************************************/
		else if(param.equals("saveEssentialMonitoringDetails")){
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custId="0";
				if(request.getParameter("custName")!=null){
				 custId=request.getParameter("custName");
				}
		
			 String stopagetimelimit=request.getParameter("stopagelimitlimit");
			 int stoptime=0;
			 try
			    {
			    if(stopagetimelimit!=null && stopagetimelimit.length()>0)
			    {
				stoptime = Integer.parseInt(stopagetimelimit);
			    }
			    }catch(Exception e)
			    {
			    	System.out.println("Index out of bound exception"+e);
			    }
					 
			 String Idle_Time="0";
				
					Idle_Time=request.getParameter("idletimelimit");
				
				int idletime=0;
				 try
				    {
				    if(Idle_Time!=null && Idle_Time.length()>0)
				    {
					idletime = Integer.parseInt(Idle_Time);
				    }
				    }catch(Exception e)
				    {
				    	System.out.println("Index out of bound exception"+e);
				    }
				String Non_Comm_Time="0";
				
					Non_Comm_Time=request.getParameter("noncommunicatinglimit");
			
				int noncommtime=0;
				try {
					 if(Non_Comm_Time!=null && Non_Comm_Time.length()>0)
					    {
						noncommtime = Integer.parseInt(Non_Comm_Time);
					    }
				} catch (Exception e) {
					System.out.println("Error getting non communicating data in customer setting action "+e.toString());
				}
				
			
				String Live_Pos_Time="0";
				
					Live_Pos_Time=request.getParameter("livepositiontime");
			
				int liveposititime=Integer.parseInt(Live_Pos_Time.trim());
				
				String Subsequent_Remainder="0";
				Subsequent_Remainder=request.getParameter("subsequentRemainder");
			    int subsequentRemainder=Integer.parseInt(Subsequent_Remainder.trim());
			    
			    String stoppageAlertInsideHub="N";
				if(request.getParameter("stoppageAlertInsideHub").trim()!=null && !request.getParameter("stoppageAlertInsideHub").trim().equals("")){
					if(request.getParameter("stoppageAlertInsideHub").equals("true"))
					{
						stoppageAlertInsideHub="Y";	
					}
				}			    
			    String Subsequent_Notification=request.getParameter("subsequentNotification");
		        int subsequentNotification=Integer.parseInt(Subsequent_Notification.trim());
		        String pageName=request.getParameter("pageName");
				String msg=adfunc.saveEssentialMonitoringDetails(custId,stoptime,idletime,noncommtime,liveposititime,subsequentRemainder,
						subsequentNotification,systemId,stoppageAlertInsideHub,pageName,sessionId,serverName,userId);
			
				response.getWriter().print(msg);
				
			} catch (Exception  e) {
				System.out.println("Exception in CustomerSettingAction:-save essential monitoring details "+e.toString());
			}
		}
		/****************************************************************************************************************************************************
		 * 													Saving Advanced Monitoring
		 *****************************************************************************************************************************************************/
		else if(param.equals("saveAdvanceMonitoringDetails")){
			try {
				double convertFactor=cf.getUnitOfMeasureConvertionsfactor(systemId);
				String custId="0";
				if(request.getParameter("custName")!=null){
				 custId=request.getParameter("custName");
				}

				
				
			 String Res_Mom_Start_Time="0.0";
				if(request.getParameter("RestrictiveMomentStart")!=null && !request.getParameter("RestrictiveMomentStart").equals("")){
					Res_Mom_Start_Time=request.getParameter("RestrictiveMomentStart").replace(':', '.');
				}
				
				float resmomstartime=Float.valueOf(Res_Mom_Start_Time.trim());
				
				
				String Res_Mom_End_time="0.0";
				if(request.getParameter("RestrictiveMomentEnd")!=null && !request.getParameter("RestrictiveMomentEnd").equals("")){
				Res_Mom_End_time=request.getParameter("RestrictiveMomentEnd").replace(':', '.');
				}
				
				
				
				float resmomendtime=Float.valueOf(Res_Mom_End_time.trim());
				//int resmomendtime=Integer.parseInt(Res_Mom_End_time.trim());
				
				String Res_Non_Mom_Start_Time="0";
					///Res_Non_Mom_Start_Time=request.getParameter("RestrictiveNoneMomentStart");
					int resnonmomstartime=Integer.parseInt(Res_Non_Mom_Start_Time.trim());
				
			
				String Res_Non_Mom_End_Time="0";
			
					//Res_Non_Mom_End_Time=request.getParameter("RestrictiveNonMomentEnd");
			
				int resnonmomeendtime=Integer.parseInt(Res_Non_Mom_End_Time.trim());
				
				
				String AC_Idle_Time="0";
			  if(request.getParameter("AcIdle")!=null && !request.getParameter("AcIdle").equals("")){
				  AC_Idle_Time=request.getParameter("AcIdle");
			  }
					
			
				int acidletime=0;
				try {
					 if(AC_Idle_Time!=null && AC_Idle_Time.length()>0)
					    {
					    acidletime = Integer.parseInt(AC_Idle_Time);
					    }
				} catch (Exception e) {
					System.out.println("Error in AC_Idle_Time in CustomerSetting Action "+e.toString());
				}
				
				
				String Near_Border="0";
	              if(request.getParameter("DistanceNearBorder")!=null && !request.getParameter("DistanceNearBorder").equals(""))
	              {
					Near_Border=request.getParameter("DistanceNearBorder");
	              }

				double nearborder=Double.parseDouble(Near_Border.trim());
				
				nearborder = Math.ceil(nearborder / convertFactor);
				
			
				String Seat_Belt_Interval="0";
		 if(request.getParameter("SeatBeltInterval")!=null && !request.getParameter("SeatBeltInterval").equals("")){
			 Seat_Belt_Interval=request.getParameter("SeatBeltInterval");
			 
		 }
			
				int seatbeltinterval=Integer.parseInt(Seat_Belt_Interval);
			
				String Door_Sensor_IntervalTime="0";
	              if(request.getParameter("DoorSensorIntervalTime")!=null && !request.getParameter("DoorSensorIntervalTime").equals(""))
	              {
	            	  Door_Sensor_IntervalTime=request.getParameter("DoorSensorIntervalTime");
	              }
				int doorsensorintervaltime=Integer.parseInt(Door_Sensor_IntervalTime.trim());
				
				String doorsensoralertinsidehub="N";
				if(request.getParameter("Doorsensoralertinsidehub").trim()!=null && !request.getParameter("Doorsensoralertinsidehub").trim().equals("")){
					if(request.getParameter("Doorsensoralertinsidehub").equals("true"))
					{
						doorsensoralertinsidehub="Y";	
					}
				}
				
				String Restrictive_Distance="0";
		if(request.getParameter("RestrictiveDistance")!=null && !request.getParameter("RestrictiveDistance").equals("")){
			Restrictive_Distance= request.getParameter("RestrictiveDistance");
			
		}
					
	
		double restrictivedistance=Double.parseDouble(Restrictive_Distance.trim());
		
		restrictivedistance=Math.ceil(restrictivedistance / convertFactor);
				
				
				String Non_Restrictive_Distance="0";

					//Non_Restrictive_Distance= request.getParameter("NonRestrictiveDistance");

				int nonrestrictivedis=Integer.parseInt(Non_Restrictive_Distance.trim());
				
				
				String seatBeltDistane="0";
				if(request.getParameter("SeatBeltDistance").trim()!=null && !request.getParameter("SeatBeltDistance").trim().equals("")){
					seatBeltDistane=request.getParameter("SeatBeltDistance").trim();
				}
				double seatbeltdistance=Double.parseDouble(seatBeltDistane);
				
				seatbeltdistance = Math.ceil(seatbeltdistance / convertFactor);
				
				String monday="N";
				if(request.getParameter("Monday").trim()!=null && !request.getParameter("Monday").trim().equals("")){
					if(request.getParameter("Monday").equals("true"))
					{
						monday="Y";	
					}
					
				}
				
				String tuesday="N";
				if(request.getParameter("Tuesday").trim()!=null && !request.getParameter("Tuesday").trim().equals("")){
					if(request.getParameter("Tuesday").equals("true"))
					{
						tuesday="Y";	
					}
				}
				
				String wednesday="N";
				if(request.getParameter("Wednesday").trim()!=null && !request.getParameter("Wednesday").trim().equals("")){
					if(request.getParameter("Wednesday").equals("true"))
					{
						wednesday="Y";	
					}
				}
				
				String thursday="N";
				if(request.getParameter("Thursday").trim()!=null && !request.getParameter("Thursday").trim().equals("")){
					if(request.getParameter("Thursday").equals("true"))
					{
						thursday="Y";	
					}
				}
				
				String friday="N";
				if(request.getParameter("Friday").trim()!=null && !request.getParameter("Friday").trim().equals("")){
					if(request.getParameter("Friday").equals("true"))
					{
						friday="Y";	
					}
				}
				
				String saturday="N";
				if(request.getParameter("Saturday").trim()!=null && !request.getParameter("Saturday").trim().equals("")){
					if(request.getParameter("Saturday").equals("true"))
					{
						saturday="Y";	
					}
				}
				
				String sunday="N";
				if(request.getParameter("Sunday").trim()!=null && !request.getParameter("Sunday").trim().equals("")){
					if(request.getParameter("Sunday").equals("true"))
					{
						sunday="Y";	
					}
				}
				
				String firstday="0";
				if(request.getParameter("FirstDayWeek").trim()!=null && !request.getParameter("FirstDayWeek").trim().equals("")){
					firstday=request.getParameter("FirstDayWeek").trim();
				}
				
				int day=Integer.parseInt(firstday.trim());
				
				String starttime="0.0";
				if(request.getParameter("STime").trim()!=null && !request.getParameter("STime").trim().equals("")){
					starttime=request.getParameter("STime").trim();
				}
				 

				float stime=Float.parseFloat(starttime);
				
				
				
				String endtime="0.0";
				if(request.getParameter("ETime").trim()!=null && !request.getParameter("ETime").trim().equals("")){
					endtime=request.getParameter("ETime").trim();
				}
				
				float etime=Float.parseFloat(endtime);
/*********************************************************************FOR RESTRICTIVE ALERT***********************************************************************************************/				
				String monday1="N";
				if(request.getParameter("Monday1").trim()!=null && !request.getParameter("Monday1").trim().equals("")){
					if(request.getParameter("Monday1").equals("true"))
					{
						monday1="Y";	
					}
					
				}
				
				String tuesday1="N";
				if(request.getParameter("Tuesday1").trim()!=null && !request.getParameter("Tuesday1").trim().equals("")){
					if(request.getParameter("Tuesday1").equals("true"))
					{
						tuesday1="Y";	
					}
				}
				
				String wednesday1="N";
				if(request.getParameter("Wednesday1").trim()!=null && !request.getParameter("Wednesday1").trim().equals("")){
					if(request.getParameter("Wednesday1").equals("true"))
					{
						wednesday1="Y";	
					}
				}
				
				String thursday1="N";
				if(request.getParameter("Thursday1").trim()!=null && !request.getParameter("Thursday1").trim().equals("")){
					if(request.getParameter("Thursday1").equals("true"))
					{
						thursday1="Y";	
					}
				}
				
				String friday1="N";
				if(request.getParameter("Friday1").trim()!=null && !request.getParameter("Friday1").trim().equals("")){
					if(request.getParameter("Friday1").equals("true"))
					{
						friday1="Y";	
					}
				}
				
				String saturday1="N";
				if(request.getParameter("Saturday1").trim()!=null && !request.getParameter("Saturday1").trim().equals("")){
					if(request.getParameter("Saturday1").equals("true"))
					{
						saturday1="Y";	
					}
				}
				
				String sunday1="N";
				if(request.getParameter("Sunday1").trim()!=null && !request.getParameter("Sunday1").trim().equals("")){
					if(request.getParameter("Sunday1").equals("true"))
					{
						sunday1="Y";	
					}
				}
				String pageName=request.getParameter("pageName");

				String msg=adfunc.saveAdvanceMonitoringDetails(custId,resmomstartime,resmomendtime,resnonmomstartime,resnonmomeendtime,acidletime,(int)nearborder,seatbeltinterval,doorsensorintervaltime,doorsensoralertinsidehub,(int)restrictivedistance,nonrestrictivedis,custId,systemId,(int)seatbeltdistance,userId,pageName,sessionId,serverName);
				
				String msg1=adfunc.saveCustomerWorkDetails(monday,tuesday,wednesday,thursday,friday,saturday,sunday,day,stime,etime,Integer.parseInt(custId),systemId,userId,1,pageName,sessionId,serverName);
				msg1=adfunc.saveCustomerWorkDetails(monday1,tuesday1,wednesday1,thursday1,friday1,saturday1,sunday1,0,0,0,Integer.parseInt(custId),systemId,userId,2,pageName,sessionId,serverName);
				
				response.getWriter().print(msg);
				
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Exception in CustomerSettingAction:-save advance monitoring details "+e.toString());
			}
		}
		/****************************************************************************************************************************************************
		 * 													Saving Trip Details
		 *****************************************************************************************************************************************************/
		else if(param.equals("saveTripDetails")){
			try {
			
//				String custId="0";
//				if(request.getParameter("custName")!=null){
//				 custId=request.getParameter("custName");
//				}

				//String msg=adfunc.saveAdvanceMonitoringDetails(custId,resmomstartime,resmomendtime,resnonmomstartime,resnonmomeendtime,acidletime,nearborder,seatbeltinterval,restrictivedistance,nonrestrictivedis,custId,systemId);

				response.getWriter().print(jsonObject.toString());
				
			} catch (Exception e) {
				System.out.println("Exception in CustomerSettingAction:-save trip details");
			}
		}
		/****************************************************************************************************************************************************
		 * 													Saving Milk Logistics
		 *****************************************************************************************************************************************************/
		else if(param.equals("saveMilkDistributionLogisticsDetails")){
			try {
				
				String custId="0";
				if(request.getParameter("custName")!=null){
				 custId=request.getParameter("custName");
				}

			
			 String Min_Temp="0";
				if(request.getParameter("MinTemp")!=null && !request.getParameter("MinTemp").equals("")){
					Min_Temp=request.getParameter("MinTemp");
				}
				
				double mintemp=Double.parseDouble(Min_Temp);
				String pageName=request.getParameter("pageName");

				String Max_temp="0";
				if(request.getParameter("MaxTemp")!=null && !request.getParameter("MaxTemp").equals("")){
					Max_temp=request.getParameter("MaxTemp");
				}
					
				double maxtemp=Double.parseDouble(Max_temp);

				String msg=adfunc.saveMilkDistributionLogisticsDetails(mintemp,maxtemp,custId,systemId,pageName,sessionId,serverName,userId);

			
				response.getWriter().print(msg);
				
			} catch (Exception e) {
				System.out.println("Exception in CustomerSettingAction:-save milk distribution logistics "+e);
			}
		}
		/****************************************************************************************************************************************************
		 * 													Saving Health and Saftey
		 *****************************************************************************************************************************************************/
		else if(param.equals("saveHealthAndSafetyDetails")){
			try {
				
				String custId="0";
				if(request.getParameter("custName")!=null){
				 custId=request.getParameter("custName");
				}

			 
			 String Over_Speed_Limit="0";

			 if(request.getParameter("BlackTop")!=null && !request.getParameter("BlackTop").equals("")){
				 Over_Speed_Limit=request.getParameter("BlackTop");
			 }
					
		
				int overspeedlimit=Integer.parseInt(Over_Speed_Limit);
				
				
				String Over_Speed_Limit_Graded="0";
				if(request.getParameter("Graded")!=null && !request.getParameter("Graded").equals("")){
					Over_Speed_Limit_Graded=request.getParameter("Graded");
				}

					
				
				int overspeedgraded=Integer.parseInt(Over_Speed_Limit_Graded);
				String pageName=request.getParameter("pageName");

				
				String msg=adfunc.saveHealthSafetyAssuranceDetails(overspeedlimit,overspeedgraded,custId,systemId,pageName,sessionId,serverName,userId);
						
				response.getWriter().print(msg);
				
			} catch (Exception e) {
				System.out.println("Exception in CustomerSettingAction:-saveHealthSafetyAssurance "+e.toString());
			}
		}
		/****************************************************************************************************************************************************
		 * 													Getting Customer Details
		 *****************************************************************************************************************************************************/	
		else if(param.equals("getCustomerSettingDetails")){
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custId="0";
				if(request.getParameter("CustId")!=null){
				 custId=request.getParameter("CustId");
				}
				jsonArray=adfunc.CustomerSettingDetails(custId,systemId);
				if(jsonArray.length()>0){
					jsonObject.put("CustomerSettingDetailsRoot", jsonArray);
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Exception in CustomerSettingAction:--getCustomerSettingDetails "+e);
			}
		}
	/****************************************************************************************************************************************************
	 * 													Saving Images in Customer Setting	
	 *****************************************************************************************************************************************************/
		else if(param.equals("saveImages")){
			try {
				Properties properties = null;
				properties = ApplicationListener.prop;
				String saveImagePath = properties.getProperty("CustomerSettingSaveImagePath");
				String custId="0";
				if(request.getParameter("CustId")!=null){
				 custId=request.getParameter("CustId");
				}
				String imageName="";
				if(request.getParameter("ImageName")!=null){
					imageName=request.getParameter("ImageName");
				}
				String pageName=request.getParameter("pageName");
				String msg=adfunc.saveImage(custId,systemId,imageName,saveImagePath,pageName,sessionId,serverName,userId);
				
				response.getWriter().print(msg);
			} catch (Exception e) {
				System.out.println("Exception in CustomerSettingAction:--saveImages "+e);
			}
		}
		return null;
	}
}
