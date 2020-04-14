package t4u.semiautomatedtrip;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
import t4u.functions.LogWriter;
import t4u.functions.SemiAutoTripFunctions;

import com.google.gson.Gson;
import com.google.gson.internal.LinkedTreeMap;

public class SemiAutoTripAction extends Action{
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		try{
			HttpSession session = request.getSession();
			String sessionId = request.getSession().getId();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd/MM/yyyy");
			SimpleDateFormat sdfLog = new SimpleDateFormat("dd-MM-yyyy");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			int isLtsp = 0;
			int nonCommHrs = 0;
			String lang = "";
			String zone="";
			SemiAutoTripFunctions semiAutoTripFunc = new SemiAutoTripFunctions();
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = null;
			String param = "";
			LogWriter logWriter = null;
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileJotun");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdfLog.format(new Date()) + "." + logFileExt;
			 String serverName = request.getServerName();
			PrintWriter pw;
			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("Inside SemiAutoTripAction " +"param : "+param+ "-- " + session.getId() + "--" + userId,LogWriter.INFO, pw);
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",LogWriter.ERROR);
				}
			}
			if(request.getParameter("param") != null){
				param = request.getParameter("param");
			}
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
				isLtsp = loginInfo.getIsLtsp();
				nonCommHrs = loginInfo.getNonCommHrs();
				lang = loginInfo.getLanguage();
				zone = loginInfo.getZone();
			}
			if(param.equalsIgnoreCase("saveTripMuscat")){
				String assetNumber = request.getParameter("assetNumber");
				String productLine = "TCL";
				String desTripDetails = request.getParameter("desTripDetails");
				String trackTripSub = request.getParameter("trackTripDetailsSub");
				String tempeartureArray=request.getParameter("tripVehicleTemperatureDetails");
				String tripCustomerId=request.getParameter("tripCustomerId");
             	String customerName=request.getParameter("customerName");
             	String custReference=request.getParameter("customerRefId");
             	String sourceHubName=request.getParameter("sourceHubName");
             	String tripStartTime = request.getParameter("tripStartTime");
             	String routeName = request.getParameter("routeName");
             	
				List desTripDetailsList = null;
				List temperatureSettingList = null;
				logWriter.log("Inside saveTrip ::assetNumber"+assetNumber, LogWriter.INFO);
				 Gson gson = new Gson(); 
		            if(desTripDetails != null){
		            	desTripDetailsList = gson.fromJson(desTripDetails, List.class);
		            }
		            LinkedTreeMap trackTripSubMap = null;
		            if(trackTripSub != null){
		            	trackTripSubMap = gson.fromJson(trackTripSub,LinkedTreeMap.class);
		            }
		            if(tempeartureArray != null){
		            	temperatureSettingList = gson.fromJson(tempeartureArray, List.class);
		            }
		         String message = semiAutoTripFunc.saveTripMuscat(assetNumber, productLine, desTripDetailsList, trackTripSubMap,
		        		 temperatureSettingList, Integer.parseInt(tripCustomerId),customerName,custReference,sourceHubName,tripStartTime,routeName,
		        		 systemId, clientId, userId,offset,logWriter);
		         
		         logWriter.log("End of saveTrip ::assetNumber"+assetNumber +"::message: "+message, LogWriter.INFO);
		         response.getWriter().print(message);
				
			}
			else if (param.equalsIgnoreCase("getSemiAutoTripDetails")) {
		        try {
		            String customerId = request.getParameter("CustId");
		            String startDate = request.getParameter("startdate");
		            String endDate = request.getParameter("enddate")+" "+ "23:59:59";
		            String statusType = request.getParameter("statusType");
		            zone = loginInfo.getZone();
		            jsonObject = new JSONObject();
		            jsonArray = new JSONArray();
		            if (customerId != null && !customerId.equals("")) {
		            	startDate = startDate.replaceAll("T", " ");
		            	endDate = endDate.replaceAll("T", " ");
		                ArrayList < Object > list1 = semiAutoTripFunc.getSemiTripDetails(systemId, Integer.parseInt(customerId),startDate,endDate,offset,userId,statusType,zone);
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("ticketDetailsRoot",jsonArray);
		                } else {
		                    jsonObject.put("ticketDetailsRoot", "");
		                }
		             	response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("ticketDetailsRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }else if (param.equals("closeSemiAutoTrip")) {
				logWriter.log("Start of SemiAutoTripAction.closeSemiAutoTrip method ", LogWriter.INFO);
				try {
					String uniqueId=request.getParameter("uniqueId");
					String vehicleNo=request.getParameter("vehicleNo");
					String remarksData=request.getParameter("remarksData");
					String tripCloseDate = request.getParameter("tripCloseDate");
					String message="";
					
					message = semiAutoTripFunc.closeSemiAutoMatedTrip(userId,Integer.parseInt(uniqueId),systemId,clientId,offset,
										vehicleNo,remarksData,tripCloseDate,logWriter);
					
					response.getWriter().print(message);
				}

				catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("cancelTrip")) {
				try {
					logWriter.log("Start of SemiAutoTripAction.cancelTrip method :::Trip Id:"+request.getParameter("uniqueId"),LogWriter.INFO);
					String uniqueId=request.getParameter("uniqueId");
					String vehicleNo = request.getParameter("vehicleNo");
					String remarks = request.getParameter("remarks");			
					String reasonId = request.getParameter("reasonId");	
					String message="";
					
					message = semiAutoTripFunc.cancelTrip(userId,Integer.parseInt(uniqueId),sessionId,serverName,userId,systemId,clientId,vehicleNo,remarks,logWriter,reasonId,offset);
					logWriter.log("End of SemiAutoTripAction.cancelTrip method :"+sessionId ,LogWriter.INFO);
					response.getWriter().print(message);
				}

				catch (Exception e) {
					logWriter.log("Error in SemiAutoTripAction.cancelTrip method :"+sessionId + e.getMessage() ,LogWriter.ERROR);
					e.printStackTrace();
				}
			}else if (param.equals("checkRS232Assoc")) {
				try {
					String vehicleNo = request.getParameter("vehicleNo");
					boolean isRS232Assocication=false;
					
					isRS232Assocication = semiAutoTripFunc.checkRS232Association(vehicleNo,systemId,clientId);
					response.getWriter().print(isRS232Assocication);
				}

				catch (Exception e) {
					logWriter.log("Error in SemiAutoTripAction.checkRS232Assoc method :"+ e.getMessage() ,LogWriter.ERROR);
					e.printStackTrace();
				}
			}else if (param.equals("getAvailableVehicles")) {
				try {
					jsonObject = new JSONObject();
					String productLine=request.getParameter("productLine");	
					
					jsonArray = semiAutoTripFunc.getAvailableVehicles(systemId,clientId, userId,productLine);
					jsonObject.put("clientVehicles", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getCustomers")) {
				try {
					jsonObject = new JSONObject();
					jsonArray = semiAutoTripFunc.getCustomers();
					jsonObject.put("customerRoot", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("getTripConfigurationDetails")) {
				try {
					jsonObject = new JSONObject();
					jsonArray = semiAutoTripFunc.getTripConfigurationDetails();
					jsonObject.put("tripDetails", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getTripConfiguration")) {
				try {
					jsonObject = new JSONObject();
					jsonArray = semiAutoTripFunc.getTripConfiguration(systemId,clientId);
					jsonObject.put("tripDetails", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("saveTripConfig")) {
				try {
					//jsonObject = new JSONObject();
					String customerId = request.getParameter("customerId");
					String systemId1 = request.getParameter("systemId");
					String tripStartCriteria = request.getParameter("tripStartCriteria");
					String tripEndCriteria = request.getParameter("tripEndCriteria");
					String tripStartCriteriaParam = request.getParameter("tripStartCriteriaParam");
					String tripEndCriteriaParam = request.getParameter("tripEndCriteriaParam");
					String routeType = request.getParameter("routeType");
					String message = semiAutoTripFunc.saveTripConfiguration(systemId1,customerId,tripStartCriteria,tripEndCriteria,tripStartCriteriaParam,tripEndCriteriaParam,routeType
							);
					response.getWriter().print(message);
			  }
				catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTripCustomers")){
				try {
					jsonObject = new JSONObject();
					jsonArray = semiAutoTripFunc.getTripCustomer(clientId, systemId);
					jsonObject.put("customerRoot", jsonArray);
					
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equalsIgnoreCase("saveMapViewSetting")){
				String mapViewSettings = request.getParameter("mapViewSettings");
				List mapViewSettingsList = null;
				Gson gson = new Gson();
				if (mapViewSettings != null) {
					mapViewSettingsList = gson.fromJson(mapViewSettings, List.class);
					System.out.println(mapViewSettingsList);
					String message = semiAutoTripFunc.saveMapViewSettings(mapViewSettingsList, systemId,clientId,zone);
					response.getWriter().print(message);
				}
			}else if(param.equalsIgnoreCase("modifyMapViewSetting")){
				String mapViewSettings = request.getParameter("mapViewSettings");
				List mapViewSettingsList = null;
				Gson gson = new Gson();
				if (mapViewSettings != null) {
					mapViewSettingsList = gson.fromJson(mapViewSettings, List.class);
					System.out.println(mapViewSettingsList);
					semiAutoTripFunc.updateMapViewSettings(mapViewSettingsList, systemId,clientId);
				}
			}else if(param.equals("getMapViewSetting")){
				try {
					
					jsonObject = new JSONObject();
					jsonArray = semiAutoTripFunc.getMapViewSettings( systemId, clientId, zone);
					jsonObject.put("mapViewSettingRoot", jsonArray);
					
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
}
