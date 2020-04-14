package t4u.GeneralVertical;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.Charset;
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
import t4u.functions.AmazonTripDashboardFunction;
import t4u.functions.CommonFunctions;
import t4u.functions.CreateLandmarkFunctions;
import t4u.functions.CreateTripFunction;
import t4u.functions.GeneralVerticalFunctions;
import t4u.functions.HistoryAnalysisFunction;
import t4u.functions.LogWriter;
import t4u.functions.SLA_DashboardExport;
import t4u.functions.UtilizationDashBoardFunction;
import t4u.functions.VehicleTrackingHistory;
import t4u.util.TemperatureConfiguration;
import t4u.util.TemperatureConfigurationBean;

import com.google.gson.Gson;
import com.google.gson.internal.LinkedTreeMap;
import com.vividsolutions.jts.geom.Coordinate;

public class TripDashBoardAction extends Action{
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			 String serverName = req.getServerName();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd/MM/yyyy");
			SimpleDateFormat ddmmyyyy2 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			int isLtsp = 0;
			int nonCommHrs = 0;
			String lang = "";
			String zone="A";
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
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			String sessionId = req.getSession().getId();
			SimpleDateFormat sdfLog = new SimpleDateFormat("dd-MM-yyyy");
			LogWriter logWriter = null;
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForTripCreation");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = logFileName + "-" + sdfLog.format(new Date()) + "." + logFileExt;
			PrintWriter pw;
			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("Inside TripDashboardAction for : "+param,LogWriter.INFO, pw);
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
			AmazonTripDashboardFunction atdf = new AmazonTripDashboardFunction();
			UtilizationDashBoardFunction util= new UtilizationDashBoardFunction();
			HistoryAnalysisFunction historyTrackingFunctions = new HistoryAnalysisFunction();
			CommonFunctions cf=new CommonFunctions();
			CreateLandmarkFunctions clf = new CreateLandmarkFunctions(); 
			CreateTripFunction creatTripFunc = new CreateTripFunction();
			
			if(param.equals("getTripSummaryDetails")){
				String groupId = req.getParameter("groupId");
				String unit = req.getParameter("unit");
				try{
					obj = new JSONObject();
						jArr = gf.getTripSummaryDetails(systemId,clientId,offset,groupId,unit,userId);
						if(jArr.length() > 0){
							obj.put("tripSummaryDetails", jArr);
						}else{
							obj.put("tripSummaryDetails", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equalsIgnoreCase("getVehicleCount")){
				try{
					obj = new JSONObject();
					jArr = gf.getVehicleCount(systemId,clientId,userId);
					obj.put("vehicleCount", jArr);
					resp.getWriter().print(obj);
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("getMapViewVehicles")) {
				try {
					obj = new JSONObject();
					jArr = gf.getMapViewVehicles(offset,userId,clientId,systemId,isLtsp,lang,nonCommHrs);
					if (jArr.length() > 0) {
						obj.put("MapViewVehicles", jArr);
					} else {
						obj.put("MapViewVehicles", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getCriticalAlert")){
				try {
					obj = new JSONObject();
					jArr = gf.getCriticalEventCout(clientId,systemId,userId);
					if (jArr.length() > 0) {
						obj.put("criticalEvents", jArr);
					} else {
						obj.put("criticalEvents", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getCheckPointsAndEventsDetails")){
				String tripNo = req.getParameter("tripNo");
				try {
					obj = new JSONObject();
					jArr = gf.getTripEvenDetails(clientId,systemId,tripNo,offset);
					if (jArr.length() > 0) {
						obj.put("tripEventsRoot", jArr);
					} else {
						obj.put("tripEventRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getSummaryDetails")){
				String tripNo = req.getParameter("tripNo");
				String alertId  ="";
				if(req.getParameter("alertId")!=null){
					alertId = req.getParameter("alertId");
				}
				try {
					obj = new JSONObject();
					jArr = gf.getSummaryDetails(clientId,systemId,tripNo,offset,alertId);
					if (jArr.length() > 0) {
						obj.put("tripSummarysRoot", jArr);
					} else {
						obj.put("tripSummarysRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getHistoryAnalysisForTripDashBoard")){
				try {
					String vehicleNo="";
					String startDateTime = "";
					String endDateTime = "";
					int tBandValueInt = 0;
					String recordForTwoMin="";
					String recordForSixhrs="";
					if(req.getParameter("vehicleNo") != null && !req.getParameter("vehicleNo").equals("")){
						vehicleNo = req.getParameter("vehicleNo");
						byte[] bytes = vehicleNo.getBytes(Charset.forName("ISO-8859-1"));
						vehicleNo = new String(bytes, Charset.forName("UTF-8"));
					}
					if(req.getParameter("startdate") != null && !req.getParameter("startdate").equals("")){
						startDateTime = req.getParameter("startdate");
					}
					if(req.getParameter("enddate") != null && !req.getParameter("enddate").equals("")){
						endDateTime = req.getParameter("enddate");
					}
					
					if(req.getParameter("timeband") != null && !req.getParameter("timeband").equals("")){
						tBandValueInt = Integer.parseInt(req.getParameter("timeband"));
					}
					obj = new JSONObject();
					if(systemId==262){
						/*
						 * 
						 * the below calling functions provide the data from the history table 
						 * Instead of from activity jar .. on further improments 
						 * we can make one  common function.
						 */
						VehicleTrackingHistory fun = new VehicleTrackingHistory();
                        jArr=fun.getVehicleTrackingHistory(vehicleNo, startDateTime, endDateTime, offset, systemId, clientId, userId);
					}else{
						jArr = historyTrackingFunctions.getVehicleTrackingHistory(vehicleNo,startDateTime,endDateTime, offset, systemId, clientId, tBandValueInt,
								recordForTwoMin,recordForSixhrs,userId);
					}
					
				
					if (jArr.length() > 0) {
						obj.put("vehiclesTrackingRoot", jArr);
					} else {
						obj.put("vehiclesTrackingRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getCriticalEventsDetails")){
				String alertId = req.getParameter("alertId");
				String groupId = req.getParameter("groupId");
				try {
					obj = new JSONObject();
					jArr = gf.getCriticalEventsDetails(clientId,systemId,alertId,offset,userId,groupId);
					if (jArr.length() > 0) {
						obj.put("criticalEventsDetails", jArr);
					} else {
						obj.put("criticalEventsDetails", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}
			else if(param.equals("getTripSummaryDetailsAmazon")){
				String groupId = req.getParameter("groupId");
				String unit = req.getParameter("unit");
				String depot = req.getParameter("depot");
				String hub = req.getParameter("hub");
				try{
					obj = new JSONObject();
					jArr=atdf.getTripSummaryDetailsAmazon(systemId, clientId, offset, groupId, unit, userId, depot, hub);
					//	jArr = gf.getTripSummaryDetailsAmazon(systemId,clientId,offset,groupId,unit,userId);
						if(jArr.length() > 0){
							obj.put("tripSummaryDetails", jArr);
						}else{
							obj.put("tripSummaryDetails", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getHistoryAnalysisForTripDashBoard1")){
				try {
					String vehicleNo="";
					String startDateTime = "";
					String endDateTime = "";
					if(req.getParameter("vehicleNo") != null && !req.getParameter("vehicleNo").equals("")){
						vehicleNo = req.getParameter("vehicleNo");
						byte[] bytes = vehicleNo.getBytes(Charset.forName("ISO-8859-1"));
						vehicleNo = new String(bytes, Charset.forName("UTF-8"));
					}
					if(req.getParameter("startdate") != null && !req.getParameter("startdate").equals("")){
						startDateTime = req.getParameter("startdate");
					}
					if(req.getParameter("enddate") != null && !req.getParameter("enddate").equals("")){
						endDateTime = req.getParameter("enddate");
					}
					obj = new JSONObject();
					jArr=gf.getHistoryInfo(vehicleNo,startDateTime,endDateTime,offset,systemId);

					if (jArr.length() > 0) {
						obj.put("vehiclesTrackingRoot", jArr);
					} else {
						obj.put("vehiclesTrackingRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			
			} else if (param.equals("getTripSummaryDetailsDHL")) {
				String groupId = req.getParameter("groupId");
				String unit = req.getParameter("unit");
				String custId = req.getParameter("custId");
				String routeId = req.getParameter("routeId");
				String status = req.getParameter("status");
				String userAuthority = req.getParameter("userAuthority");
				String startDateRange = req.getParameter("startDateRange");
				String endDateRange = req.getParameter("endDateRange");
				String custType = req.getParameter("custType");
				String tripType = req.getParameter("tripType");
				String count = req.getParameter("count");
				try {
					obj = new JSONObject();
					if (loginInfo != null) {
						jArr = gf.getTripSummaryDetailsDHL(systemId, clientId, offset, groupId, unit, userId, custId,
								routeId, status, userAuthority, startDateRange, endDateRange, custType, tripType,
								count, zone);

						if (jArr.length() > 0) {
							obj.put("tripSummaryDetails", jArr);
						} else {
							obj.put("tripSummaryDetails", "");
						}
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		else if(param.equals("getLegDetailsForTrip")){
			String tripNo = req.getParameter("tripId");
			String tripStatus = req.getParameter("tripStatus");
			String delay = req.getParameter("delay");
			try{
				obj = new JSONObject();
					jArr = gf.getLegDetailsForTrip(offset,tripNo,tripStatus,delay,zone);
					if(jArr.length() > 0){
						obj.put("legDetails", jArr);
					}else{
						obj.put("legDetails", "");
					}
				resp.getWriter().print(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("getLegWiseSLAReport")){
			String range = req.getParameter("range");
			String customerId=req.getParameter("customerId");
			String startDate = req.getParameter("startDate");
			String endDate = req.getParameter("endDate");
			String route = req.getParameter("routeId");
			String tripCustId = req.getParameter("tripCustId");
			String custType = req.getParameter("custType");
			String tripType = req.getParameter("tripType");
			String hubType = req.getParameter("hubType");
			String hubDirection = req.getParameter("hubDirection");
			String type = req.getParameter("selectedType");
			try{
				String  message = gf.getLegwiseDetailsForSLA(offset,Integer.parseInt(range),Integer.parseInt(customerId),startDate,endDate,zone,userId,route,tripCustId,custType,tripType,hubType,hubDirection,type);
				resp.getWriter().print(message);
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("getIssuesData")){
			try {
				obj = new JSONObject();
				jArr = gf.getIssues(clientId);
				obj.put("issueRoot", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getSubIssuesData")){
		String issueType = req.getParameter("issuetype");
			try {
				obj = new JSONObject();
				jArr = gf.getsubIssues(clientId,issueType);
				obj.put("subissues", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("saveRemarkDetails")){
			String custName = req.getParameter("Custname");
			String checked=req.getParameter("checked");
			String Remarks = req.getParameter("remarks");
			String tripId = req.getParameter("tripId");
			String flag=req.getParameter("flag");
			String locationdelay=req.getParameter("locationdelay");
			String startdate=req.getParameter("startdate");
			String enddate=req.getParameter("enddate");
			String delaytime=req.getParameter("delaytime");
			String issue=req.getParameter("issue");
			String subissue=req.getParameter("subissue");
			int uniqueId=Integer.parseInt(req.getParameter("uniqueid"));
			String customerId = req.getParameter("customerId");
			String message="";
			try{
				obj = new JSONObject();	
				if(flag.equals("add"))
				{
				message = gf.insertRemarksDetails(systemId,userId,custName,Remarks,tripId,checked,locationdelay,startdate,enddate,delaytime,issue,subissue,customerId);		
				}
				else if(flag.equals("update"))
				{
				message = gf.updateRemarksDetails(systemId,userId,custName,Remarks,tripId,checked,uniqueId,locationdelay,startdate,enddate,delaytime,issue,subissue,customerId);			
				}
				obj.put("remarksRoot",message);
				resp.getWriter().print(message.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("editRemarkDetails")){
			String tripId = req.getParameter("tripId");
			try{
				obj = new JSONObject();
					jArr = gf.getRemarksDetails(systemId,tripId,userId,offset);
					if(jArr.length() > 0){
						obj.put("indentMasterRoot1", jArr);
					}else{
						obj.put("indentMasterRoot1", "");
					}
				resp.getWriter().print(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("viewDetails")){
			String tripId = req.getParameter("tripId");
			try{
				obj = new JSONObject();
					jArr = gf.getViewDetails(systemId,tripId,userId,offset);
					if(jArr.length() > 0){
						obj.put("Root", jArr);
					}else{
						obj.put("Root", "");
					}
				resp.getWriter().print(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("getTripSummaryDetailsForReport")){
			String CustId = req.getParameter("CustId");
			String unit = cf.getUnitOfMeasure(systemId);
			String startDate = req.getParameter("startdate");
            String endDate = req.getParameter("enddate");
            String tripCustomerName = req.getParameter("tripCustomerName");
			try{
				obj = new JSONObject();
					jArr = gf.getTripSummaryDetailsForReport(systemId,Integer.parseInt(CustId),offset,unit,userId,startDate,endDate,tripCustomerName,zone);
					if(jArr.length() > 0){
						obj.put("tripSummaryDetailsgrid", jArr);
					}else{
						obj.put("tripSummaryDetailsgrid", "");
					}
				resp.getWriter().print(obj.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "Trip Summary Report", "View", userId, serverName, systemId, clientId,
				"Visited This Page");
			}catch(Exception e){
				e.printStackTrace();
			}
		}
			else if (param.equalsIgnoreCase("getVehiclesForMap")) {
				try {
					obj = new JSONObject();
					//String custName = req.getParameter("custName");
					String custId = req.getParameter("custId");
					String routeId = req.getParameter("routeId");
					String status=req.getParameter("status");
					String custType = req.getParameter("custType");
					String tripType = req.getParameter("tripType");
					jArr = gf.getVehiclesForMap(offset,userId,clientId,systemId,isLtsp,lang,nonCommHrs,custId,routeId,status,custType,tripType);
					if (jArr.length() > 0) {
						obj.put("MapViewVehicles", jArr);
					} else {
						obj.put("MapViewVehicles", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getDashBoardCounts")){
				String routeId = req.getParameter("routeId");
				String custId = req.getParameter("custId");
				String custType = req.getParameter("custType");
				String tripType = req.getParameter("tripType");
				String count = req.getParameter("count");
				try {
					obj = new JSONObject();
					if(count!=null && Integer.parseInt(count) > 0){
						jArr = gf.getDashBoardCounts(clientId,systemId,userId,custId,routeId,custType,tripType);
					} else {
						jArr = gf.getStaticDashBoardCounts(clientId,systemId);
					}
					if (jArr.length() > 0) {
						obj.put("vehicleCounts", jArr);
					} else {
						obj.put("vehicleCounts", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getAlertCounts")){
				String routeId = req.getParameter("routeId");
				String custId = req.getParameter("custId");
				String custType = req.getParameter("custType");
				String tripType = req.getParameter("tripType");
				String count = req.getParameter("count");
				try {
					obj = new JSONObject();
					if(count!=null && Integer.parseInt(count) > 0){
						jArr = gf.getAlertCounts(clientId, systemId, userId,custId,routeId,custType,tripType);
					} else {
						jArr = gf.getAlertDashBoardCounts(clientId,systemId);
					}
					if (jArr.length() > 0) {
						obj.put("alertCounts", jArr);
					} else {
						obj.put("alertCounts", "");
					}
					resp.getWriter().print(obj.toString());
					
					
				} catch (Exception e) {

				}
			}else if(param.equals("getAlertDetails")){
				String tripId = req.getParameter("tripId");
				String alertId=req.getParameter("alertId");
				String custId = req.getParameter("custId");
				String routeId = req.getParameter("routeId");
				String custType = req.getParameter("custType");
				String tripType = req.getParameter("tripType");
				try {
					obj = new JSONObject();
					jArr = gf.getAlertDetails(clientId, systemId, userId,alertId,tripId,offset,custId,routeId,custType,tripType);
					if (jArr.length() > 0) {
						obj.put("alertDetails", jArr);
					} else {
						obj.put("alertDetails", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if (param.equals("getRouteNames")) {
				try {
					jArr = gf.getRoutes(systemId,clientId);
					resp.getWriter().print(jArr.toString());
				
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("getCustNames")) {
				try {
					jArr = gf.getCustNames(clientId, systemId);
					resp.getWriter().print(jArr.toString());
				
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equals("updateRemarks")) {
				try {
					String uniqueId=req.getParameter("uniqueId");
					String remarks1=req.getParameter("remarks");
					String message="";
					message = gf.updateRemarks(systemId,uniqueId,remarks1,userId);
					resp.getWriter().print(message);
				}
				
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			else if(param.equals("getCustomerList")){
				try{
					obj = new JSONObject();
						jArr = gf.getCustomerDetails(systemId,clientId);
						if(jArr.length() > 0){
							obj.put("customeList", jArr);
						}else{
							obj.put("customeList", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getCustNamesSLA")){
				try{
					
					obj = new JSONObject();
						jArr = gf.getCustNamesSLA(systemId,clientId,userId);
						if(jArr.length() > 0){
							obj.put("customeList", jArr);
						}else{
							obj.put("customeList", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getRouteList")){
				try{
					obj = new JSONObject();
					String custIds= req.getParameter("customerList").trim();
					  jArr = gf.getRouteDetails(systemId,clientId,custIds);
						if(jArr.length() > 0){
							obj.put("routeListRoot", jArr);
						}else{
							obj.put("routeListRoot", "");
						}
					resp.getWriter().print(obj.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Executive Static View", "View", userId, serverName, systemId, clientId,
					"Visited This Page/Dashboard");
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			else if(param.equals("getDetailstoPanel")){
				try{
					obj = new JSONObject();
					String customerList = req.getParameter("customerList").trim();
					String routeList = req.getParameter("selectedRoute").trim();
					String range= req.getParameter("range").trim();
					String comaparsion= req.getParameter("comaparsion").trim();
					//String ExeArrayElemets=req.getParameter("jsonArray");
					// JSONArray exedata=new JSONArray(ExeArrayElemets.toString());
					  jArr = gf.getTruckDetails(systemId,clientId,customerList,routeList,Integer.parseInt(range),Integer.parseInt(comaparsion),offset);
						if(jArr.length() > 0){
							obj.put("dashboardRoot", jArr);
						}else{
							obj.put("dashboardRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getDetailstoOnTimePanel")){
				try{
					obj = new JSONObject();
					String customerList = req.getParameter("customerList").trim();
					String routeList = req.getParameter("selectedRoute").trim();
					String range= req.getParameter("range").trim();
					String comaparsion= req.getParameter("comaparsion").trim();
					  jArr = gf.getOntimeTruckDetails(systemId,clientId,customerList,routeList,Integer.parseInt(range),Integer.parseInt(comaparsion),offset);
						if(jArr.length() > 0){
							obj.put("OnTimedashboardRoot", jArr);
						}else{
							obj.put("OnTimedashboardRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getDetailstoDelayPanel")){
				try{
					obj = new JSONObject();
					String customerList = req.getParameter("customerList").trim();
					String routeList = req.getParameter("selectedRoute").trim();
					String range= req.getParameter("range").trim();
					String comaparsion= req.getParameter("comaparsion").trim();
					  jArr = gf.getDelayTruckDetails(systemId,clientId,customerList,routeList,Integer.parseInt(range),Integer.parseInt(comaparsion),offset);
						if(jArr.length() > 0){
							obj.put("DelaydashboardRoot", jArr);
						}else{
							obj.put("DelaydashboardRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}	else if(param.equals("getDetailstoSmarttruckPanel")){
				try{
					obj = new JSONObject();
					String customerList = req.getParameter("customerList").trim();
					String routeList = req.getParameter("selectedRoute").trim();
					String range= req.getParameter("range").trim();
					String comaparsion= req.getParameter("comaparsion").trim();
					  jArr = gf.getSmartTruckDetails(systemId,clientId,customerList,routeList,Integer.parseInt(range),Integer.parseInt(comaparsion),offset);
						if(jArr.length() > 0){
							obj.put("SmartTruckdashboardRoot", jArr);
						}else{
							obj.put("SmartTruckdashboardRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getDetailstoTwentyTwoPanel")){
				try{
					obj = new JSONObject();
					String customerList = req.getParameter("customerList").trim();
					String routeList = req.getParameter("selectedRoute").trim();
					String range= req.getParameter("range").trim();
					String comaparsion= req.getParameter("comaparsion").trim();
					  jArr = gf.getTwentyTwoFeetTruckDetails(systemId,clientId,customerList,routeList,Integer.parseInt(range),Integer.parseInt(comaparsion),"22 FEET",offset);
						if(jArr.length() > 0){
							obj.put("twentytwodashboardRoot", jArr);
						}else{
							obj.put("twentytwodashboardRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getDetailstoTwentyFourPanel")){
				try{
					obj = new JSONObject();
					String customerList = req.getParameter("customerList").trim();
					String routeList = req.getParameter("selectedRoute").trim();
					String range= req.getParameter("range").trim();
					String comaparsion= req.getParameter("comaparsion").trim();
					  jArr = gf.getTwentyTwoFeetTruckDetails(systemId,clientId,customerList,routeList,Integer.parseInt(range),Integer.parseInt(comaparsion),"24 FEET",offset);
						if(jArr.length() > 0){
							obj.put("twentyFourdashboardRoot", jArr);
						}else{
							obj.put("twentyFourdashboardRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getDetailstoThirtyTwoPanel")){
				try{
					obj = new JSONObject();
					String customerList = req.getParameter("customerList").trim();
					String routeList = req.getParameter("selectedRoute").trim();
					String range= req.getParameter("range").trim();
					String comaparsion= req.getParameter("comaparsion").trim();
					  jArr = gf.getTwentyTwoFeetTruckDetails(systemId,clientId,customerList,routeList,Integer.parseInt(range),Integer.parseInt(comaparsion),"32 FEET",offset);
						if(jArr.length() > 0){
							obj.put("thirtytwodashboardRoot", jArr);
						}else{
							obj.put("thirtytwodashboardRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getUnassignedVehicles")){
				//String customerName=req.getParameter("customerList");
				//String routeId=req.getParameter("routeList");
				//String productLine = req.getParameter("productLine");
				
				String customerList = req.getParameter("customerList").trim();
				String routeList = req.getParameter("selectedRoute").trim();
				String productList= req.getParameter("productList").trim();
				
				obj = new JSONObject();
				//jArr = gf.getDashBoardDetails(systemId,clientId,customerName,routeId,productLine);
				jArr = gf.getDashBoardDetails(systemId,clientId,customerList,routeList,productList);
				if(jArr.length() > 0){
					obj.put("dashboardDetais", jArr);
				}else{
					obj.put("dashboardDetails", "");
				}
				resp.getWriter().print(obj.toString());
			}
			else if(param.equals("getPanalDetails")){
				String uniqueId=req.getParameter("uniqueId");
				obj = new JSONObject();
					jArr=gf.getPanalDetails(uniqueId,systemId,clientId);
					if(jArr.length() > 0){
						obj.put("TableDetails", jArr);
					}else{
						obj.put("TableDetails", "");
					}
					resp.getWriter().print(obj.toString());
			}
			else if(param.equals("getAssignedEnroutePlaceDetails")){
				String customerId=req.getParameter("customerList");
				String routeId=req.getParameter("routeList");
				String uniqueId=req.getParameter("uniqueId");
				String productLine = req.getParameter("productLine");
				obj = new JSONObject();
				jArr=gf.getAssignedEnroutePlaceDetails(uniqueId,systemId,clientId,customerId,routeId ,productLine);
				if(jArr.length() > 0){
					obj.put("TableDetails", jArr);
				}else{
					obj.put("TableDetails", "");
				}				
				resp.getWriter().print(obj.toString());
				
				
			}else if (param.equals("getLatLongs")) {
				String routeId=req.getParameter("routeId");
				try {
					jArr = gf.getLatLongs(Integer.parseInt(routeId), systemId);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("latLongRoot",jArr);
					}else{
						obj.put("latLongRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }
			
			else if (param.equals("getSmartTruckAlertCount")) {
				try {
					jArr = gf.getSmartTruckAlert(systemId,clientId);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("alertCountRoot",jArr);
					}else{
						obj.put("alertCountRoot","");
					}
					resp.getWriter().print(obj.toString());	
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Smart Trucker Behaviour", "View", userId, serverName, systemId, clientId,
					"Visited This Page/Dashboard");
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }
			else if (param.equals("getSmartTruckAlertCountRemarked")) {
				try {
					jArr = gf.getSmartTruckAlertRemarked(systemId,clientId);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("alertCountRemarkedRoot",jArr);
					}else{
						obj.put("alertCountRemarkedRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }
			else if(param.equals("getSmartTruckAlertDetails")){
				String alertId=req.getParameter("alertId");
				String vehicleNo=req.getParameter("vehicleNo");
				try {
					obj = new JSONObject();
					jArr = gf.getSamartTruckerAlertDetails(systemId,clientId, userId,alertId,offset,vehicleNo);
					if (jArr.length() > 0) {
						obj.put("alertDetails", jArr);
					} else {
						obj.put("alertDetails", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}//
			else if(param.equals("getSmartTruckDriverAlertDetails")){
				String alertId=req.getParameter("alertId");
				String driverId=req.getParameter("driverId");
				String groupId=req.getParameter("groupId");
				
				//StringBuffer sbf=new StringBuffer(vehicleNo);
				//sbf.deleteCharAt(0);
				//sbf.deleteCharAt(sbf.length()-1);
				//vehicleNo=String.valueOf(sbf);
				//String name=req.getParameter("name");
				try {
					obj = new JSONObject();
					jArr = gf.getSamartTruckerDriverAlertDetails(systemId,clientId, userId,alertId,offset,Integer.parseInt(driverId),groupId);
					if (jArr.length() > 0) {
						obj.put("alertDetails", jArr);
					} else {
						obj.put("alertDetails", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}//
			else if(param.equals("getSmartTruckAlertDetailsNonRemark")){
				try {
					obj = new JSONObject();
					jArr = gf.getSamartTruckerAlertDetailsNonRemark(systemId,clientId,offset);
					if (jArr.length() > 0) {
						obj.put("alertDetailsNonRemark", jArr);
					} else {
						obj.put("alertDetailsNonRemark", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("smartTruckerDetails")) {
				try {
					
					String groupId=req.getParameter("groupId");
					jArr = gf.getSmartTruckTableDetails(systemId,clientId,offset,groupId);
					obj = new JSONObject();
					if(jArr.length()>0){
						obj.put("smartTruckerDetails",jArr);
					}else{
						obj.put("smartTruckerDetails","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }
			else if(param.equals("getOEMMakeList"))
			{
				try{
					obj = new JSONObject();
						jArr = gf.getOEMMakeDetails(systemId,clientId);
						if(jArr.length() > 0){
							obj.put("OEMMakeList", jArr);
						}else{
							obj.put("OEMMakeList", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getVehicleList"))
			{
				try{
					obj = new JSONObject();
					String OEMMake= req.getParameter("OEMMake").trim();					
					  jArr = gf.getOEMVehicleDetails(systemId,clientId,OEMMake);
						if(jArr.length() > 0){
							obj.put("vehicleListRoot", jArr);
						}else{
							obj.put("vehicleListRoot", "");
						}						
					resp.getWriter().print(obj.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Smart Truck Health", "View", userId, serverName, systemId, clientId,
					"Visited This Page/Dashboard");
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getTruckTypeList"))
			{
				try{
					obj = new JSONObject();
					String TruckType= req.getParameter("TruckType").trim();
					  jArr = gf.getTruckTypeList(systemId,clientId,TruckType);
						if(jArr.length() > 0){
							obj.put("truckTypeList", jArr);
						}else{
							obj.put("truckTypeList", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getSmartTruckHealthDBDetails"))
			{
				//String OEMMakeId=req.getParameter("Make").trim();
				//String vehicleId=req.getParameter("vehicleId").trim();
				//String typeId=req.getParameter("truckTypeList").trim();
				String makeList=req.getParameter("makeList").trim();
				String vehicleList=req.getParameter("vehicleList").trim();
				String truckTypeList=req.getParameter("truckTypeList").trim();
				try{
					obj = new JSONObject();
					
					  //jArr = gf.getSmartTruckHealthDBDetails(systemId,clientId,OEMMakeId,vehicleId,typeId);
					  jArr = gf.getSmartTruckHealthDBDetails(systemId,clientId,makeList,vehicleList,truckTypeList);
						if(jArr.length() > 0){
							obj.put("smartTruckHealthAlertDetails", jArr);
						}else{
							obj.put("smartTruckHealthAlertDetails", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}	
			}
			if(param.equals("getSmartTruckHealthAlertDetails")){
				
				String alertId=req.getParameter("uniqueId");
				String vehicleId=req.getParameter("vehicleId");
				String vehicleType=req.getParameter("vehicleType");
				String oemMake=req.getParameter("oemMake");
								
				try {
					obj = new JSONObject();
					jArr = gf.getSmartTruckHealthAlertDetails(systemId,clientId,alertId,oemMake,vehicleId,vehicleType,offset);
					if (jArr.length() > 0) {
						obj.put("TruckHealthAlertDetails", jArr);
					} else {
						obj.put("TruckHealthAlertDetails", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}
			else if (param.equals("updateActionTaken")) {
				try {
					int uniqueId=Integer.parseInt(req.getParameter("uniqueId"));
					String remarks=req.getParameter("remarks");
					String message="";
					message = gf.updateActionTaken(systemId,clientId,remarks,uniqueId);
					resp.getWriter().print(message);
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("updateActionTakenEngineCoolant"))
			{
				try {
					String uniqueId=req.getParameter("uniqueId");
					String remarks=req.getParameter("remarks");
					int errorCode=Integer.parseInt(req.getParameter("errorCode")); 
					//String gmt=req.getParameter("gmttime");
					String message="";
					message = gf.updateActionTakenEngineCoolant(systemId,clientId,remarks,uniqueId,errorCode);
					resp.getWriter().print(message);
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getVehiclesForAdminDashboard")) {
				try {
					obj = new JSONObject();
					String status=req.getParameter("status");
					jArr = gf.getVehiclesForAdminDashboard(offset,userId,clientId,systemId,status);
					if (jArr.length() > 0) {
						obj.put("MapViewVehicles1", jArr);
					} else {
						obj.put("MapViewVehicles1", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}
			
			/* Driver Performance Report */
			else if(param.equals("getDriverPerformaceInfo")){
				//String clientId = req.getParameter("clientId");
				String dateRange = req.getParameter("dateRange");
				String[] dates = dateRange.split("-");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
				String startDate =dates[0].trim().replace("/", "-")+" 00:00:00";
				String endDate = dates[1].trim().replace("/", "-")+" 23:59:59";
				
				
				System.out.println(sdf.format(sdf1.parse(startDate))+" -  "+sdf.format(sdf1.parse(endDate)));
				try {
					obj = new JSONObject();
					jArr = gf.getDriverPerformaceInformation(clientId,systemId,offset,sdf.format(sdf1.parse(startDate)),sdf.format(sdf1.parse(endDate)));
					if (jArr.length() > 0) {
						obj.put("DriverPerformace", jArr);
					} else {
						obj.put("DriverPerformace", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getTempDetails")){
				try {
					JSONObject jsonObject = new JSONObject();
					String regNo = req.getParameter("vehicleNo");
					String startdate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("startdate")));
					String enddate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("enddate")));					
					String category = req.getParameter("category");
					category = category.replaceAll(",$", "");
					String hourlyData = req.getParameter("hourlyRange");
					obj = new JSONObject();
					if(Integer.parseInt(hourlyData)==1)
						jArr = gf.getTempDetails(systemId,clientId,offset,userId,startdate,enddate,regNo,category);
					else
						jArr = gf.getIndividualTemperatureReportBasedOnTimeRange(systemId,clientId,offset,userId,startdate,enddate,regNo,category,hourlyData);
					if (jArr.length() > 0) {
						jsonObject.put("tempRoot", jArr);
					} else {
						jsonObject.put("tempRoot", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTempCount")){
				String regNo = req.getParameter("vehicleNo");
				boolean f2S =req.getParameter("startdate").contains("-");
				boolean f2E =req.getParameter("enddate").contains("-");
				String startdate = (f2S)?yyyyMMdd.format(ddmmyyyy2.parse(req.getParameter("startdate"))):yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("startdate")));
				String enddate = (f2E)?yyyyMMdd.format(ddmmyyyy2.parse(req.getParameter("enddate2"))):yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("enddate")));
				String tripId = req.getParameter("tripId");
				try {
					obj = new JSONObject();
					jArr = gf.getTempCount(regNo,offset,startdate,enddate,tripId,systemId,clientId);
					if (jArr.length() > 0) {
						obj.put("tempCounts", jArr);
					} else {
						obj.put("tempCounts", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getTemperatureReport")){
				try {
					JSONObject jsonObject = new JSONObject();
					String regNo = req.getParameter("vehicleNo");
					String startdate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("startdate")));
					String enddate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("enddate")));
					String hourlyData = req.getParameter("hourlyRange");
					obj = new JSONObject();
					if(Integer.parseInt(hourlyData)==1)
					jArr = gf.getTemperatureReport(systemId,clientId,offset,userId,startdate,enddate,regNo);
					else
					jArr = gf.getTemperatureReportBasedOnTimeRange(systemId,clientId,offset,userId,startdate,enddate,regNo,hourlyData);
					if (jArr.length() > 0) {
						jsonObject.put("tempReportRoot", jArr);
					} else {
						jsonObject.put("tempReportRoot", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {  
					e.printStackTrace();
				}
			}else if(param.equals("getVehicles")){
				try {
					JSONObject jsonObject = new JSONObject();
					obj = new JSONObject();
					jArr = gf.getVehicles(systemId,clientId,offset,userId);
					if (jArr.length() > 0) {
						jsonObject.put("vehicleDetails", jArr);
					} else {
						jsonObject.put("vehicleDetails", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTrip")){
				try {
					JSONObject jsonObject = new JSONObject();
					String custId = req.getParameter("custId");
					obj = new JSONObject();
					jArr = gf.getTrip(systemId,clientId,offset,userId,custId);
					if (jArr.length() > 0) {
						jsonObject.put("tripNames", jArr);
					} else {
						jsonObject.put("tripNames", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTripData")){
				try {
					JSONObject jsonObject = new JSONObject();
					String tripId=req.getParameter("tripId");
					obj = new JSONObject();
					jArr = gf.getTripData(offset,Integer.parseInt(tripId));
					if (jArr.length() > 0) {
						jsonObject.put("tripData", jArr);
					} else {
						jsonObject.put("tripData", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getAllTempDetails")){
				try {
					JSONObject jsonObject = new JSONObject();
					String regNo = req.getParameter("vehicleNo");
					String startdate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("startdate")));
					String enddate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("enddate")));
					obj = new JSONObject();
					jArr = gf.getAllTempValues(systemId,clientId,offset,userId,startdate,enddate,regNo);
					if (jArr.length() > 0) {
						jsonObject.put("tempRoot1", jArr);
					} else {
						jsonObject.put("tempRoot1", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getDriverPerformanceData")){
				String startDate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
	            String endDate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
	            int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) 
		            	|| "ALL".equalsIgnoreCase(req.getParameter("driverId")) ? "0" : req.getParameter("driverId"));
	            String  hubList = req.getParameter("hubList");
				try{
					jArr = gf.getDriverPerformanceData(systemId,clientId,offset,startDate,endDate,driverId,hubList,zone);
					obj = new JSONObject();
					if(jArr.length() > 0){
						obj.put("driverPerformanceRoot", jArr);
					}else{
						obj.put("driverPerformanceRoot", "");
					}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getTopOrBottomDriverDetails")){
				try {
					obj = new JSONObject();
					String startDate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
					String endDate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
					String orderBy = req.getParameter("order");
					int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) 
			            	|| "ALL".equalsIgnoreCase(req.getParameter("driverId")) ? "0" : req.getParameter("driverId"));
		            String  hubList = req.getParameter("hubList");
					jArr = gf.getTopOrBottomdDriverDetails(systemId,clientId,offset,startDate,endDate,orderBy,driverId,hubList,zone);
					if (jArr.length() > 0) {
						obj.put("top3Data", jArr);
					} else {
						obj.put("top3Data", "");
					}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getDriverPerformanceDataForChart")){
				try {
					String startDate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
		            String endDate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
		            int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) 
		            	|| "ALL".equalsIgnoreCase(req.getParameter("driverId")) ? "0" : req.getParameter("driverId"));
		            String  hubList = req.getParameter("hubList");
					obj = new JSONObject();
					jArr = gf.getDriverPerformanceDataForChart(systemId, clientId,offset,startDate,endDate,driverId,hubList,zone);
					if (jArr.length() > 0) {
						obj.put("chartDataRoot", jArr);
					} else {
						obj.put("chartDataRoot", "");
					}
					resp.getWriter().print(obj.toString());
					cf.insertDataIntoAuditLogReport(sessionId, null, "Driver Performance Dashboard", "View", userId, serverName, systemId, clientId,
					"Viewed This Page/Dashboard");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getDriverSummaryData")){
				try {
					String startDate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
		            String endDate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
		            int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) 
		            	|| "ALL".equalsIgnoreCase(req.getParameter("driverId")) ? "0" : req.getParameter("driverId"));
		            String  hubList = req.getParameter("hubList");
					
					jArr = gf.getDriverSummaryData(systemId, clientId,offset, startDate, endDate,driverId,hubList,zone);
					obj = new JSONObject();
					if (jArr.length() > 0) {
						obj.put("driverSummaryDataRoot", jArr);
					} else {
						obj.put("driverSummaryDataRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getOverallScore")){
				String hubList = req.getParameter("hubList"); 
				int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) ? "0" 
						: req.getParameter("driverId"));
				try {
					obj = new JSONObject();
					jArr = gf.getOverallScore(systemId,clientId,offset,driverId,hubList,zone);
					if (jArr.length() > 0) {
						obj.put("overallRoot", jArr);
					} else {
						obj.put("overallRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}else if(param.equals("getPerformanceDetails")){
				String startDate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
				int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) ||
						"ALL".equalsIgnoreCase(req.getParameter("driverId")) ? "0" : req.getParameter("driverId"));
				String hubList = req.getParameter("hubList");
				try {
					obj = new JSONObject();
					jArr = gf.getPerformanceDetails(systemId,clientId,offset,startDate,endDate,driverId,hubList,zone);
					if (jArr.length() > 0) {
						obj.put("performanceRoot", jArr);
					} else {
						obj.put("performanceRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
				}
			}else if(param.equals("getColumnChartDetails")){
				try {
					JSONObject jsonObject = new JSONObject();
					String driverId = req.getParameter("driverId");
					String startdate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
					String enddate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
					String hubList = req.getParameter("hubList");
					obj = new JSONObject();
					jArr = gf.getColumnChartDetails(systemId,clientId,offset,userId,driverId,startdate,enddate,hubList,zone);
					if (jArr.length() > 0) {
						jsonObject.put("columnRoot", jArr);
					} else {
						jsonObject.put("columnRoot", "");
					}
					resp.getWriter().print(jsonObject.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Driver Performance Dashboard", "View", userId, serverName, systemId, clientId,
					"Visited This Page/Dashboard");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equalsIgnoreCase("getSortCenterVehicleCount")){
				try{
					obj = new JSONObject();
					jArr = atdf.getVehicleCount(systemId,clientId,userId);
					obj.put("vehicleCount", jArr);
					resp.getWriter().print(obj);
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			 else if(param.equals("getSortCenterList")){
					try {
						obj = new JSONObject();
							jArr = atdf.getSortCenter(clientId,systemId);
							if (jArr.length() > 0) {
								obj.put("SortCenterRoot", jArr);
							} else {
								obj.put("SortCenterRoot", "");
							}
						resp.getWriter().print(obj.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				} 
		else if(param.equals("getHubList")){
			try {
				obj = new JSONObject();
				jArr = atdf.getHubNames(clientId, systemId);
				if (jArr.length() > 0) {
					obj.put("hubRoot", jArr);
				} else {
					obj.put("hubRoot", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		}
		else if(param.equals("getDriverPerformanceCount")){
			String startDate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
            String endDate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
            int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) ||
				"ALL".equalsIgnoreCase(req.getParameter("driverId")) ? "0" : req.getParameter("driverId"));
            String hubList = req.getParameter("hubList");
			try{
				jArr = gf.getDriverCountDetails(systemId,clientId,offset,startDate,endDate,driverId,hubList,zone);
				obj = new JSONObject();
				if(jArr.length() > 0){
					obj.put("driverPerformanceCountRoot", jArr);
				}else{
					obj.put("driverPerformanceCountRoot", "");
				}
				resp.getWriter().print(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("getUnAssigendVehiclesLatLng")){
			try {
				
				jArr = new JSONArray();
				obj = new JSONObject();
				jArr = gf.getUnAssigendVehiclesLatLng(offset,clientId,systemId);
				if (jArr.length() > 0) {
					obj.put("UnAssignedLatLng", jArr);
				} else {
					obj.put("UnAssignedLatLng", "");
				}
				//System.out.println("Un "+jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {

			}
		}
		else if(param.equals("getAssigendEnrouteVehiclesLatLng")){
			try 
			{
				jArr = new JSONArray();
				obj = new JSONObject();
				jArr = gf.getAssigendEnrouteVehiclesLatLng(offset,clientId,systemId);
				if (jArr.length() > 0) {
					obj.put("AssignedEnroutedLatLng", jArr);
				} else {
					obj.put("AssignedEnroutedLatLng", "");
				}
				//System.out.println("Un "+jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
			}
		}
		else if(param.equals("getAssigendPlacedVehiclesLatLng")){
			try 
			{
				jArr = new JSONArray();
				obj = new JSONObject();
				jArr = gf.getAssigendPlacedVehiclesLatLng(offset,clientId,systemId);
				if (jArr.length() > 0) {
					obj.put("AssignedPlacedLatLng", jArr);
				} else {
					obj.put("AssignedPlacedLatLng", "");
				}
				//System.out.println("Un "+jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
		}
		}	
		else if(param.equals("getFutureAvailableTrucks")){
			try 
			{
				String hrs = req.getParameter("hrs");
				jArr = new JSONArray();
				obj = new JSONObject();
				jArr = gf.getTrucksAvailable(Integer.parseInt(hrs),offset,clientId,systemId);
				if (jArr.length() > 0) {
					obj.put("futureAvailbleTruck", jArr);
				} else {
					obj.put("futureAvailbleTruck", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getDriverDetails")){
			try 
			{
				String status = req.getParameter("status");
				jArr = new JSONArray();
				obj = new JSONObject();
				jArr = gf.getDriverDetails(clientId,systemId,status);
				if (jArr.length() > 0) {
					obj.put("driverIndex", jArr);
				} else {
					obj.put("driverIndex", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getRouteLists"))
		{
			try{
				obj = new JSONObject();
				String custList= req.getParameter("custList").trim();				
				  jArr = gf.getRouteVehicleDetails(systemId,clientId,custList);				  
					if(jArr.length() > 0){
						obj.put("routeListRoot", jArr);
					}else{
						obj.put("routeListRoot", "");
					}					
				resp.getWriter().print(obj.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "Executive Live View", "View", userId, serverName, systemId, clientId,
				"Visited This Page/Dashboard");
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if (param.equals("getCustNamesForSLA123")) {
			try {
				jArr = gf.getCustNamesForSLA(clientId, systemId);
				resp.getWriter().print(jArr.toString());
			
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getCustNamesForSLA")){
			try {
				obj = new JSONObject();
				jArr = gf.getCustNamesForSLA(clientId, systemId);
				obj.put("customerRoot", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			// changed implementation logic by @Guru on 26-11-2019
			// current implementation is implemented excluding the maintenance
			// vehicles
			// else if(param.equals("getVehicleCountJson")){
			// try {
			// obj = new JSONObject();
			// jArr=util.getCountDetails(systemId, clientId);
			// obj.put("CountIndex", jArr);
			// resp.getWriter().print(obj.toString());
			// } catch (Exception e) {
			// e.printStackTrace();
			// }
			// }
			
		else if(param.equals("getAssignedVehicleCountJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getCountDetails(systemId, clientId, "getAssignedVehicleCountJson",vehicleCatgry,vehicleType,hubType);
				obj.put("CountIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getAssignedEmptyTripVehicleCountJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getCountDetails(systemId, clientId, "getAssignedEmptyTripVehicleCountJson",vehicleCatgry,vehicleType,hubType);
				obj.put("CountIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getAssignedCustomerTripVehicleCountJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getCountDetails(systemId, clientId, "getAssignedCustomerTripVehicleCountJson",vehicleCatgry,vehicleType,hubType);
				obj.put("CountIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		/*else if(param.equals("getmaintancelessOrgreather12hrs")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getCountDetails(systemId, clientId, "getmaintancelessOrgreather12hrs",vehicleCatgry,vehicleType,hubType);
				obj.put("CountIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}*/
		else if(param.equals("getUnAssignedVehicleCountJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getCountDetails(systemId, clientId, "getUnAssignedVehicleCountJson",vehicleCatgry,vehicleType,hubType);
				obj.put("CountIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMaintenanceVehicleCountJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getCountDetails(systemId, clientId, "getMaintenanceVehicleCountJson",vehicleCatgry,vehicleType,hubType);
				obj.put("CountIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMaintenanceInsideSCCountJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getCountDetails(systemId, clientId, "getMaintenanceInsideSCCountJson",vehicleCatgry,vehicleType,hubType);
				obj.put("CountIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMaintenanceEnrouteSCCountJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getCountDetails(systemId, clientId, "getMaintenanceEnrouteSCCountJson",vehicleCatgry,vehicleType,hubType);
				obj.put("CountIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

//		else if(param.equals("getVehiclesDetails")){
//			try {
//				obj = new JSONObject();
//				String statusId= req.getParameter("statusId").trim();
//				jArr = util.getListView(systemId,clientId,Integer.parseInt(statusId),offset);
//				obj.put("ListViewIndex", jArr);
//				resp.getWriter().print(obj.toString());
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//		}
		else if(param.equals("getAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"all",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMaintenanceVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,"all",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getCommAssignedVehiclesDaywiseDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				Integer hourId= Integer.parseInt(req.getParameter("hourId").trim());
				if(hourId == 2){
					jArr = util.getAssignedListView(systemId,clientId,offset,"lessThan2hrComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 5){
					jArr = util.getAssignedListView(systemId,clientId,offset,"between2To5hrComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 7){
					jArr = util.getAssignedListView(systemId,clientId,offset,"moreThan5hrComm",vehicleCatgry,vehicleType,hubType);
				}else {
					jArr = util.getAssignedListView(systemId,clientId,offset,"moreThan10hrComm",vehicleCatgry,vehicleType,hubType);
				}
				
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getNonCommAssignedVehiclesDaywiseDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				Integer hourId= Integer.parseInt(req.getParameter("hourId").trim());
				if(hourId == 2){
					jArr = util.getAssignedListView(systemId,clientId,offset,"lessThan2hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 5){
					jArr = util.getAssignedListView(systemId,clientId,offset,"between2To5hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 7){
					jArr = util.getAssignedListView(systemId,clientId,offset,"moreThan5hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else{
					jArr = util.getAssignedListView(systemId,clientId,offset,"moreThan10hrNonComm",vehicleCatgry,vehicleType,hubType);
				}
				
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getCommUnassignedVehiclesDaywiseDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				Integer hourId= Integer.parseInt(req.getParameter("hourId").trim());
				if(hourId == 2){
					jArr = util.getUnassignedListView(systemId,clientId,offset,"lessThan2hrComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 5){
					jArr = util.getUnassignedListView(systemId,clientId,offset,"between2To5hrComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 7){
					jArr = util.getUnassignedListView(systemId,clientId,offset,"moreThan5hrComm",vehicleCatgry,vehicleType,hubType);
				}else{
					jArr = util.getUnassignedListView(systemId,clientId,offset,"moreThan10hrComm",vehicleCatgry,vehicleType,hubType);
				}
				
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getNonCommUnassignedVehiclesDaywiseDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				Integer hourId= Integer.parseInt(req.getParameter("hourId").trim());
				if(hourId == 2){
					jArr = util.getUnassignedListView(systemId,clientId,offset,"lessThan2hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 5){
					jArr = util.getUnassignedListView(systemId,clientId,offset,"between2To5hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 7){
					jArr = util.getUnassignedListView(systemId,clientId,offset,"moreThan5hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else{
					jArr = util.getUnassignedListView(systemId,clientId,offset,"moreThan10hrNonComm",vehicleCatgry,vehicleType,hubType);
				}
				
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getNonCommMaintenanceVehiclesDaywiseDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				Integer hourId= Integer.parseInt(req.getParameter("hourId").trim());
				if(hourId == 2){
					jArr = util.getMaintenanceListView(systemId,clientId,offset,"lessThan2hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 5){
					jArr = util.getMaintenanceListView(systemId,clientId,offset,"between2To5hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else if(hourId == 7){
					jArr = util.getMaintenanceListView(systemId,clientId,offset,"moreThan5hrNonComm",vehicleCatgry,vehicleType,hubType);
				}else{
					jArr = util.getMaintenanceListView(systemId,clientId,offset,"moreThan10hrNonComm",vehicleCatgry,vehicleType,hubType);
				}
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getInsideSHVehiclesDaywiseDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				String type = req.getParameter("type").trim();
				String mStatus = req.getParameter("mStatus").trim();
				Integer hourId= Integer.parseInt(req.getParameter("hourId").trim());
				
				if(type.equalsIgnoreCase("Assigned")){
					if(mStatus.equalsIgnoreCase("Moved")){
						jArr = util.getAssignedListView(systemId,clientId,offset,"movedInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Halted")){
						jArr = util.getAssignedListView(systemId,clientId,offset,"haltedInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Idling")){
						jArr = util.getAssignedListView(systemId,clientId,offset,"idlingInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 2){
						jArr = util.getAssignedListView(systemId,clientId,offset,"insideSH2hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 5){
						jArr = util.getAssignedListView(systemId,clientId,offset,"insideSH5hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 7){
						jArr = util.getAssignedListView(systemId,clientId,offset,"insideSH7hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 10){
						jArr = util.getAssignedListView(systemId,clientId,offset,"insideSH10hr",vehicleCatgry,vehicleType,hubType);
					}
				}else if(type.equalsIgnoreCase("Unassigned")){
					
					if(mStatus.equalsIgnoreCase("Moved")){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"movedInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Halted")){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"haltedInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Idling")){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"idlingInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 2){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"insideSH2hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 5){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"insideSH5hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 7){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"insideSH7hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 10){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"insideSH10hr",vehicleCatgry,vehicleType,hubType);
					}
				}else{
					if(mStatus.equalsIgnoreCase("Moved")){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"movedInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Halted")){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"haltedInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Idling")){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"idlingInsideSH",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 2){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"insideSH2hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 5){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"insideSH5hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 7){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"insideSH7hr",vehicleCatgry,vehicleType,hubType);
					}else if(hourId == 10){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"insideSH10hr",vehicleCatgry,vehicleType,hubType);
					}
				}
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getCommAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"communicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getEmptyOrCustomerVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				String type = req.getParameter("type").trim();
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,type,vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			
			
		
		else if(param.equals("getMaintenanceInsideOrEnrouteDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				String type = req.getParameter("type").trim();
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,type,vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if(param.equals("getmaintancelessOrgreather12hrs")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				String type = req.getParameter("type").trim();
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,type,vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getNonCommAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"nonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getHaltedCommAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"haltedCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getIdlingCommAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"idlingCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMovedCommAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"movedCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getHaltedNonCommAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"haltedNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getIdlingNonCommAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"idlingNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMovedNonCommAssignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getAssignedListView(systemId,clientId,offset,"movedNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"all",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			
		else if(param.equals("getCommUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"communicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getCommMaintenanceVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,"communicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getNonCommUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"nonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getNonCommMaintenanceVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,"nonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getHaltedCommUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"haltedCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getHaltedCommMaintenanceVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,"haltedCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getIdlingCommUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"idlingCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMovedCommUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"movedCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getHaltedNonCommUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"haltedNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getHaltedNonCommMaintenanceVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,"haltedNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getIdlingNonCommUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"idlingNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getIdlingNonCommMaintenanceVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,"idlingNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMovedNonCommUnassignedVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getUnassignedListView(systemId,clientId,offset,"movedNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}		
		else if(param.equals("getMovedNonCommMaintenanceVehiclesDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getMaintenanceListView(systemId,clientId,offset,"movedNonCommunicating",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if(param.equals("getAssignedVehicleDaysJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getDayDetails(systemId, clientId,offset, "AssignedVehicles",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if(param.equals("getAssignedVehicleSTPGreatherThan2DaysJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getSTPGreathenThan2DayDetails(systemId, clientId,offset, "AssignedVehiclesSTPGreatherThan2Days",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if(param.equals("getUnassignedVehicleDaysJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getDayDetails(systemId, clientId,offset, "UnassignedVehicles",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMaintenanceVehicleDaysJson")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr=util.getDayDetails(systemId, clientId,offset, "MaintenanceVehicles",vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getListViewsForAll")){
			try {
				obj = new JSONObject();
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				String type= req.getParameter("type").trim();
				String mStatus= req.getParameter("mStatus").trim();
				Integer days= Integer.parseInt(req.getParameter("days").trim());
				
				
				if(type.equalsIgnoreCase("Assigned")){
					if(mStatus.equalsIgnoreCase("Moved")){
						jArr = util.getAssignedListView(systemId,clientId,offset,"Moved",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Idling")){
						jArr = util.getAssignedListView(systemId,clientId,offset,"Idling",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Halted")){
						jArr = util.getAssignedListView(systemId,clientId,offset,"Halted",vehicleCatgry,vehicleType,hubType);
					}else if(days == 2){
						jArr = util.getAssignedListView(systemId,clientId,offset,"2hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 5){
						jArr = util.getAssignedListView(systemId,clientId,offset,"5hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 7){
						jArr = util.getAssignedListView(systemId,clientId,offset,"7hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 10){
						jArr = util.getAssignedListView(systemId,clientId,offset,"10hr",vehicleCatgry,vehicleType,hubType);
					}
				}else if(type.equalsIgnoreCase("Unassigned")){
					
					if(mStatus.equalsIgnoreCase("Moved")){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"Moved",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Idling")){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"Idling",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Halted")){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"Halted",vehicleCatgry,vehicleType,hubType);
					}else if(days == 2){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"2hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 5){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"5hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 7){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"7hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 10){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"10hr",vehicleCatgry,vehicleType,hubType);
					}
				}else if(type.equalsIgnoreCase("Maintenance")){
					if(mStatus.equalsIgnoreCase("Moved")){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"Moved",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Idling")){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"Idling",vehicleCatgry,vehicleType,hubType);
					}else if(mStatus.equalsIgnoreCase("Halted")){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"Halted",vehicleCatgry,vehicleType,hubType);
					}else if(days == 2){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"2hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 5){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"5hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 7){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"7hr",vehicleCatgry,vehicleType,hubType);
					}else if(days == 10){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"10hr",vehicleCatgry,vehicleType,hubType);
					}
				}
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getListViewsForAllMaps")){
			try {
				obj = new JSONObject();
				String type = req.getParameter("type").trim();
				String mStatus = req.getParameter("mStatus").trim();
				Integer days = Integer.parseInt(req.getParameter("days").trim());
                String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				
				if(type.equalsIgnoreCase("Assigned")){
					jArr = util.getAssignedVehiclesMapDetails(systemId, clientId, offset, days, mStatus,vehicleCatgry,vehicleType,hubType);
				}else if(type.equalsIgnoreCase("Unassigned")){
					jArr = util.getUnassignedVehiclesMapDetails(systemId, clientId, offset, days, mStatus,vehicleCatgry,vehicleType,hubType);
				}else if(type.equalsIgnoreCase("Maintenance")){
					jArr = util.getMaintenanceVehiclesMapDetails(systemId, clientId, offset, days, mStatus,vehicleCatgry,vehicleType,hubType);
				}
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getLoadingStatusCounts")){
			try {
				obj = new JSONObject();
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				jArr = util.getLoadingStatusCounts(systemId,clientId,vehicleCatgry,vehicleType,hubType);	
				obj.put("Counts", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if(param.equals("getLoadingStatusDetails")){
			try {
				obj = new JSONObject();
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				String type = req.getParameter("type").trim();
				jArr = util.getAssignedLoadingUnloadingDetails(systemId,clientId,offset,type,vehicleCatgry,vehicleType,hubType);
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if(param.equals("getLoadingStatusMapDetails")){
			try {
				obj = new JSONObject();
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				String type = req.getParameter("type").trim();
				jArr = util.getAssignedLoadingUnloadingMapDetails(systemId, clientId, offset, type,vehicleCatgry,vehicleType,hubType);
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getEmptyOrCustomerStatusMapDetails")){
			try {
				obj = new JSONObject();
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				String type = req.getParameter("type").trim();
				jArr = util.getAssignedLoadingUnloadingMapDetails(systemId, clientId, offset, type,vehicleCatgry,vehicleType,hubType);
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getAssignedVehiclesMapDetails")){
			try {
				obj = new JSONObject();
				String commStatus = req.getParameter("commStatus").trim();
				String moveStatus = req.getParameter("moveStatus").trim();
				Integer days = Integer.parseInt(req.getParameter("days").trim());
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				
				jArr = util.getAssignedVehiclesForMap(systemId, clientId, offset, commStatus, days, moveStatus,vehicleCatgry,vehicleType,hubType);
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getAssignedVehiclesMapDetailsForISH")){
			try {
				obj = new JSONObject();
				String moveStatus = req.getParameter("moveStatus").trim();
				Integer days = Integer.parseInt(req.getParameter("days").trim());
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				
				jArr = util.getAssignedVehiclesMapDetailsForISH(systemId, clientId, offset, days, moveStatus,vehicleCatgry, vehicleType,hubType);
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getUnassignedVehiclesMapDetails")){
			try {
				obj = new JSONObject();
				String commStatus = req.getParameter("commStatus").trim();
				String moveStatus = req.getParameter("moveStatus").trim();
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				Integer days = Integer.parseInt(req.getParameter("days").trim());
				
				jArr = util.getUnassignedVehiclesForMap(systemId, clientId, offset, commStatus, days, moveStatus,vehicleCatgry, vehicleType,hubType);
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMaintenanceVehiclesMapDetails")){
			try {
				obj = new JSONObject();
				String commStatus = req.getParameter("commStatus").trim();
				String moveStatus = req.getParameter("moveStatus").trim();
				Integer days = Integer.parseInt(req.getParameter("days").trim());
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				
				jArr = util.getMaintenanceVehiclesForMap(systemId, clientId, offset, commStatus, days, moveStatus,vehicleCatgry, vehicleType,hubType);
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			
		/*else if(param.equals("getMaintenance12hrsDetails")){
			try {
				obj = new JSONObject();
				String commStatus = req.getParameter("commStatus").trim();
				String moveStatus = req.getParameter("moveStatus").trim();
				Integer days = Integer.parseInt(req.getParameter("days").trim());
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				
				jArr = util.getMaintenanceVehiclesForMap(systemId, clientId, offset, commStatus, days, moveStatus,vehicleCatgry, vehicleType,hubType);
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}*/
		else if(param.equals("getUnassignedVehiclesMapDetailsForISH")){
			try {
				obj = new JSONObject();
				String moveStatus = req.getParameter("moveStatus").trim();
				Integer days = Integer.parseInt(req.getParameter("days").trim());
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				
				jArr = util.getUnassignedVehiclesMapDetailsForISH(systemId, clientId, offset, days, moveStatus,vehicleCatgry, vehicleType,hubType);
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getMaintenanceVehiclesMapDetailsForISH")){
				try {
					obj = new JSONObject();
					String vehicleCatgry = req.getParameter("vehicleCat");
					String vehicleType = req.getParameter("vehicleType");
					String hubType = req.getParameter("hubType");
					String moveStatus = req.getParameter("moveStatus").trim();
					Integer days = Integer.parseInt(req.getParameter("days").trim());
					
					jArr = util.getMaintenanceVehiclesMapDetailsForISH(systemId, clientId, offset, days, moveStatus,vehicleCatgry, vehicleType,hubType );
					obj.put("MapViewIndex", jArr);
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		else if(param.equals("getInsideSHCounts")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getInsideSHCounts(systemId,clientId,offset,vehicleCatgry,vehicleType,hubType);
				obj.put("ISHCounts", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getInsideSHDetails")){
			try {
				obj = new JSONObject();
				String type = req.getParameter("type").trim();
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				
				if(type.equalsIgnoreCase("Assigned")){
					jArr = util.getAssignedListView(systemId,clientId,offset,"insideSH",vehicleCatgry,vehicleType,hubType);	
				}else if(type.equalsIgnoreCase("Unassigned")){
					jArr = util.getUnassignedListView(systemId,clientId,offset,"insideSH",vehicleCatgry,vehicleType,hubType);
				}else{
					jArr = util.getMaintenanceListView(systemId,clientId,offset,"insideSH",vehicleCatgry,vehicleType,hubType);
				}
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getTripTypeWiseMapListView")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				String type = req.getParameter("type").trim();
				jArr = util.getAssignedVehiclesForMapBasedOnTripType(systemId,clientId,offset,type,vehicleCatgry,vehicleType,hubType);	
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getTripTypeWiseListView")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				String type = req.getParameter("type").trim();
				jArr = util.getAssignedListView(systemId,clientId,offset,type,vehicleCatgry,vehicleType,hubType);	
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getTripTypeWiseCounts")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getTripTypeWiseCounts(systemId,clientId,vehicleCatgry,vehicleType,hubType);	
				obj.put("Counts", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if(param.equals("getExtraTravelledKMSCount")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				jArr = util.getExtraTravelledKMSCount(systemId,clientId,offset,vehicleCatgry,vehicleType,hubType);
				obj.put("extraKMS", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getExtraTravelledKMSDetails")){
			try {
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				obj = new JSONObject();
				String type = req.getParameter("type").trim();
				Integer distance = Integer.parseInt(req.getParameter("distance").trim());
				
				if(type.equalsIgnoreCase("Unassigned")){
					if(distance == 50){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"extraKm50",vehicleCatgry,vehicleType,hubType);
					}else if(distance == 100){
						jArr = util.getUnassignedListView(systemId,clientId,offset,"extraKm100",vehicleCatgry,vehicleType,hubType);
					}
				}else if(type.equalsIgnoreCase("Maintenance")){
					if(distance == 50){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"extraKm50",vehicleCatgry,vehicleType,hubType);
					}else if(distance == 100){
						jArr = util.getMaintenanceListView(systemId,clientId,offset,"extraKm100",vehicleCatgry,vehicleType,hubType);
					}
				}
				
				obj.put("List", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getExtraTravelledKMSDetailsMaps")){
			try {
				obj = new JSONObject();
				String type = req.getParameter("type").trim();
				Integer distance = Integer.parseInt(req.getParameter("distance").trim());
				String vehicleCatgry = req.getParameter("vehicleCat");
				String vehicleType = req.getParameter("vehicleType");
				String hubType = req.getParameter("hubType");
				
				if(type.equalsIgnoreCase("Unassigned")){
					if(distance == 50){
						jArr = util.getUnassignedExtraTravelledKMSDetailsMaps(systemId,clientId,offset,"extraKm50",vehicleCatgry,vehicleType,hubType);
					}else if(distance == 100){
						jArr = util.getUnassignedExtraTravelledKMSDetailsMaps(systemId,clientId,offset,"extraKm100",vehicleCatgry,vehicleType,hubType);
					}
				}else if(type.equalsIgnoreCase("Maintenance")){
					if(distance == 50){
						jArr = util.getMaintenanceExtraTravelledKMSDetailsMaps(systemId,clientId,offset,"extraKm50",vehicleCatgry,vehicleType,hubType);
					}else if(distance == 100){
						jArr = util.getMaintenanceExtraTravelledKMSDetailsMaps(systemId,clientId,offset,"extraKm100",vehicleCatgry,vehicleType,hubType);
					}
				}
				
				obj.put("MapViewIndex", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			//---------------------------//
		else if(param.equals("getAllCustomer")){
			try {
				obj = new JSONObject();
				jArr = util.getCustomerDetails(systemId);
				obj.put("customerRoot", jArr);
				resp.getWriter().print(obj.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "Utilization Dashboard Configuration", "View", userId, serverName, systemId, clientId,
				"Visited This Page");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getUtilConfDetails")){
			try {
				obj = new JSONObject();
				jArr = util.getUtilConfig(systemId, clientId);
				obj.put("UtilConfDetails", jArr);
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("insertUtilConfig")){
			try {
				String custId= req.getParameter("custId").trim();
				String nonCommMin= req.getParameter("nonCommMin").trim();
				String alertDist= req.getParameter("alertDist").trim();
				String mailList= req.getParameter("mailList").trim();
				String speedlimit= req.getParameter("speedlimit").trim();
			    String message = util.InsertUtilConfig(Integer.parseInt(nonCommMin),Integer.parseInt(alertDist),mailList,Integer.parseInt(speedlimit), systemId, Integer.parseInt(custId));
				resp.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("updateUtilConfig")){
			try {
				String id=req.getParameter("id").trim();
				//String custId= req.getParameter("custId").trim();
				String nonCommMin= req.getParameter("nonCommMin").trim();
				String alertDist= req.getParameter("alertDist").trim();
				String mailList= req.getParameter("mailList").trim();
				//String speedlimit= req.getParameter("speedlimit").trim();
			    String message = util.UpdateUtilConfig(Integer.parseInt(id), Integer.parseInt(nonCommMin),Integer.parseInt(alertDist),mailList);
				resp.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getOnTripVehiclesStoppage")){
			try{
				obj = new JSONObject();
				  jArr = gf.getOnTripVehiclesStoppage(systemId,clientId,zone);				  
					if(jArr.length() > 0){
						obj.put("tripVehiclesStoppage", jArr);
					}else{
						obj.put("tripVehiclesStoppage", "");
					}					
				resp.getWriter().print(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("insertOnTripVehicleStoppageAction")){
			try{
				obj = new JSONObject();
				String tripId = req.getParameter("tripId");
				String status = "OPEN";
				String stoppageBegin = req.getParameter("stoppageBegin");
				String message = "";
				if(systemId >0){
					message = gf.onTripVehStoppageActoinRemindMeLater(Integer.parseInt(tripId),status,userId, systemId, clientId,stoppageBegin);
				}
				resp.getWriter().print(message);
			}catch(Exception e){
				e.printStackTrace();
			}
		 }else if(param.equals("updateOnTripVehicleStoppageAction")){
				try{
					obj = new JSONObject();
					String tripId = req.getParameter("tripId");
					String stoppageBegin = req.getParameter("stoppageBegin");
					String remarks = req.getParameter("remarks");
					String status = req.getParameter("status");
					String duration = req.getParameter("duration");
					String lat = req.getParameter("latitude");
					String lon = req.getParameter("longitude");
					String location = req.getParameter("location");
					String message = "";
					message = gf.onTripVehStoppageActionTaken(Integer.parseInt(tripId),status,userId, systemId, clientId,
																stoppageBegin,remarks,duration,lat,lon,location);
					resp.getWriter().print(message);
				}catch(Exception e){
					e.printStackTrace();
				}
			} else if (param.equals("getOnTripVehiclesStoppageActionDetails")) {
				try {
					obj = new JSONObject();
					if(loginInfo != null){
						jArr = gf.getOnTripVehiclesStoppageActionDetails(systemId, clientId, userId, zone, isLtsp, offset);
						if (jArr.length() > 0) {
							obj.put("tripVehiclesStoppageAction", jArr);
						} else {
							obj.put("tripVehiclesStoppageAction", "");
						}
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		else if(param.equals("checkIfVehicleInsideWhichHub")){
			try{
				String modfiedHubs = req.getParameter("modfiedHubs");
				String modfiedPolyHubs = req.getParameter("modfiedPolyHubs");
				double vehicleLat = Double.parseDouble(req.getParameter("vehicleLat"));
				double vehicleLng = Double.parseDouble(req.getParameter("vehicleLng"));
				obj = new JSONObject();
				Gson g = new Gson();
				ArrayList<Integer> vehicleInsideHubId = new ArrayList<Integer>();
				List modfiedHubsList = g.fromJson(modfiedHubs, List.class); 
				Coordinate vehCoord = new Coordinate(vehicleLat, vehicleLng);
				 for(int i=0; i <modfiedHubsList.size(); i++){
			 		LinkedTreeMap treeMap = (LinkedTreeMap)modfiedHubsList.get(i);
			 		
			 		int id = Integer.parseInt(treeMap.get("id").toString());
			 		double hubLat = Double.parseDouble(treeMap.get("lat").toString());
			 		double hubLng = Double.parseDouble(treeMap.get("lng").toString());
			 		double radius = Double.parseDouble(treeMap.get("radius").toString());
					Coordinate hubCoord = new Coordinate(hubLat, hubLng);
			 		if(cf.isVehicleInsideHub(vehCoord, hubCoord, radius)){
			 			vehicleInsideHubId.add(id);
			 		}
				 }
				 List modfiedPolyHubsList = g.fromJson(modfiedPolyHubs, List.class); 
				 for(int i=0; i <modfiedPolyHubsList.size(); i++){
			 		LinkedTreeMap treeMap = (LinkedTreeMap)modfiedPolyHubsList.get(i);
			 		int id = Integer.parseInt(treeMap.get("id").toString());
			 		ArrayList<Double> latList =  ((ArrayList<Double>)treeMap.get("lat"));
			 		ArrayList<Double> lngList =  ((ArrayList<Double>)treeMap.get("lng"));
			 		Coordinate[] coords = new Coordinate[latList.size()+1];
			 		Coordinate firsthubCoord = new Coordinate(latList.get(0), lngList.get(0));
			 		int j=0;
			 		for(j=0; j< latList.size();j++){
			 			Coordinate hubCoord = new Coordinate(latList.get(j), lngList.get(j));
			 			coords[j] = hubCoord;
			 		}
			 		coords[j] = firsthubCoord;
			 		if(cf.isVehicleInsidePolygon(vehCoord, coords)){
			 			vehicleInsideHubId.add(id);
			 		}
				 }
				 if(vehicleInsideHubId.size() == 0){
					 resp.getWriter().print("Vehicle not inside hub");
				 }
				 else if(vehicleInsideHubId.size() >1){
					 resp.getWriter().print("Vehicle inside more than one hub");
				 }else{
			 			jArr =  clf.getLocationDetailsByHubId(vehicleInsideHubId.get(0));
			 			if(jArr.length() > 0){
							obj.put("hubDetails", jArr);
						}else{
							obj.put("hubDetails", "");
						}	
			 			resp.getWriter().print(obj.toString());
				 }
			}catch(Exception e){
				e.printStackTrace();
			}
		  }
		else if (param.equalsIgnoreCase("getSmartHubBufferWithinGivenLatLngRadius")) {
			try {
				int tripCustId=0;
				if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
					tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
				}
				double vehicleLat = Double.parseDouble(req.getParameter("vehicleLat"));
				double vehicleLng = Double.parseDouble(req.getParameter("vehicleLng"));
				double radiusWithin = 5.0;
				jArr = new JSONArray();
				obj = new JSONObject();
				jArr = gf.getSmartHubBufferWithinGivenLatLngRadius( userId,clientId,systemId,zone,isLtsp,tripCustId,vehicleLat,vehicleLng,radiusWithin);
				if (jArr.length() > 0) {
					obj.put("BufferMapView", jArr);
				} else {
					obj.put("BufferMapView", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equalsIgnoreCase("getSmartHubPolygonWithinGivenLatLngRadius")) {
			try {
				int tripCustId=0;
				if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
					tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
				}
				double vehicleLat = Double.parseDouble(req.getParameter("vehicleLat"));
				double vehicleLng = Double.parseDouble(req.getParameter("vehicleLng"));
				double radiusWithin = 5.0;
				jArr = new JSONArray();
				obj = new JSONObject();
				jArr = gf.getSmartHubPolygonWithinGivenLatLngRadius(userId,clientId,systemId,zone,isLtsp,tripCustId,vehicleLat,vehicleLng,radiusWithin);
				if (jArr.length() > 0) {
					obj.put("PolygonMapView", jArr);
				} else {
					obj.put("PolygonMapView", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {

			}
		}
		else if(param.equals("getAmazonReportDetails"))
		{
			String startDate=req.getParameter("startDate");
			String endDate=req.getParameter("endDate");
			try {
				obj = new JSONObject();
				jArr = atdf.getAmazonReportDetails(systemId,clientId,startDate,endDate,offset);
				if (jArr.length() > 0) {
					obj.put("AmazonReportDetails", jArr);
				} else {
					obj.put("AmazonReportDetails", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getAmazonDateTimeReportDetails"))
		{
			String startDate=req.getParameter("startDate");
			String endDate=req.getParameter("endDate");
			try {
				obj = new JSONObject();
				jArr = atdf.getAmazonDateTimeReportDetails(systemId,clientId,startDate,endDate);
				if (jArr.length() > 0) {
					obj.put("AmazonDateTimeReportDetails", jArr);
				} else {
					obj.put("AmazonDateTimeReportDetails", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		else if(param.equals("GenerateExportExcel")){
			SLA_DashboardExport exp= new SLA_DashboardExport();
			String groupId = req.getParameter("groupId");
			String unit = req.getParameter("unit");
			//String custName = req.getParameter("custName");
			String custId = req.getParameter("custId");
			String routeId = req.getParameter("routeId");
			String status=req.getParameter("status");
			String startDateRange = req.getParameter("startDateRange");
			String endDateRange = req.getParameter("endDateRange");
			String custType = req.getParameter("custType");
			String tripType = req.getParameter("tripType");
			String count = req.getParameter("count");
			try{
				obj = new JSONObject();

					jArr =null;
					String  message = exp.dashExportData(systemId,clientId,offset,groupId,unit,userId,custId,routeId,status,startDateRange,endDateRange,custType,tripType,count,zone);
					resp.getWriter().print(message);
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("getVehicleAndVendorCount")){
			String startDate=req.getParameter("startDate");
			String endDate=req.getParameter("endDate");
			try {
				obj = new JSONObject();
				jArr = atdf.getVehicleAndVendorCount(systemId,clientId,startDate,endDate);
				if (jArr.length() > 0) {
					obj.put("VehicleVendorCountRoot", jArr);
				} else {
					obj.put("VehicleVendorCountRoot", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getDateList")){
			try {
				obj = new JSONObject();
				jArr=atdf.getDateList();
				if (jArr.length() > 0) {
					obj.put("DateListRoot", jArr);
				} else {
					obj.put("DateListRoot", "");	
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getAmazonDateWiseReportDetails"))
		{
			String startDate=req.getParameter("startDate");
			
			try {
				obj = new JSONObject();
				jArr = atdf.getAmazonDateWiseReportDetails(systemId,clientId,startDate);
				if (jArr.length() > 0) {
					obj.put("AmazonDateReportDetails", jArr);
				} else {
					obj.put("AmazonDateReportDetails", "");
				}
				resp.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
			
		else if(param.equals("getTempConfigurations"))
		{
				String regNo = req.getParameter("regNo");
				try {
					List<TemperatureConfigurationBean> tempConfigDetails = TemperatureConfiguration.getTemperatureConfigurationDetails(systemId,clientId, regNo);
					obj = new JSONObject();
					List<String> headerArray = new ArrayList<String>();
					List<String> hArray = new ArrayList<String>();

					for (TemperatureConfigurationBean aTempConfigDetails : tempConfigDetails) {
						headerArray.add(aTempConfigDetails.getName());
						hArray.add(aTempConfigDetails.getSensorName());
					}
					jArr.put(headerArray);
					jArr.put(hArray);
					if (jArr.length() > 0) {
						obj.put("tempConfigDetails", jArr);
					} else {
						obj.put("tempConfigDetails", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getPlacementDelayedTrip")){
				try{
					obj = new JSONObject();
					
					 String placemnetDelayGetAll = req.getParameter("placemnetDelayGetAll");
					  jArr = gf.getPlacementDelayedTrip(systemId,clientId,offset,placemnetDelayGetAll);				  
						if(jArr.length() > 0){
							obj.put("placementDelayedTrip", jArr);
						}else{
							obj.put("placementDelayedTrip", "");
						}					
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			  }
			else if(param.equals("acknowledgeTripDelay")){
				try{
					String tripId=req.getParameter("uniqueId");
					String remarks=req.getParameter("remarks");
		            String atp = req.getParameter("atp");
		            String atd = req.getParameter("atd");
		            String vehicleNo = req.getParameter("vehicleNo");
					String message="";
					if(!atp.equals("") && !atd.equals("")){
						creatTripFunc.updateTripActualTime(atp, atd,"",offset,systemId,clientId,vehicleNo,Integer.parseInt(tripId),remarks,userId,
								null,null,serverName,"",false,false,false);
					}
					message = gf.updateTripDelayAcknowledgement(tripId,remarks,systemId,clientId,userId);
  				    resp.getWriter().print(message);			
				}catch(Exception e){
					e.printStackTrace();
				}
			  }	
			else if(param.equals("getDriverScoreValueData")){
				String startDate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
	            String endDate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
	            int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) ||
	    				"ALL".equalsIgnoreCase(req.getParameter("driverId")) ? "0" : req.getParameter("driverId"));
	            String hubList = req.getParameter("hubList");
				try{
					jArr = gf.getDriverScoreValueData(systemId,clientId,offset,startDate,endDate,driverId,hubList,zone);
					obj = new JSONObject();
					if(jArr.length() > 0){
						obj.put("driverPerformanceRoot", jArr);
					}else{
						obj.put("driverPerformanceRoot", "");
					}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getTripDelaySmartHubBuffer"))
			{
				try {
					int tripCustId=0;
					if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
						tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
					}
					jArr = new JSONArray();
					obj = new JSONObject();
					jArr = gf.getTripDelaySmartHubBuffer(userId,clientId,systemId,zone,isLtsp,tripCustId);
					if (jArr.length() > 0) {
						obj.put("TripDelayBufferMapView", jArr);
					} else {
						obj.put("TripDelayBufferMapView", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getTripDelaySmartHubPolygon")) {
				try {
					int tripCustId=0;
					if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
						tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
					}
					jArr = new JSONArray();
					obj = new JSONObject();
					jArr = gf.getTripDelaySmartHubPolygon(userId,clientId,systemId,zone,isLtsp,tripCustId);
					if (jArr.length() > 0) {
						obj.put("TripDelayPolygonMapView", jArr);
					} else {
						obj.put("TripDelayPolygonMapView", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
				
			} 
			else if(param.equals("GenerateCustomerExportExcel")){
				SLA_DashboardExport exp= new SLA_DashboardExport();
				String groupId = req.getParameter("groupId");
				String unit = req.getParameter("unit");
				//String custName = req.getParameter("custName");
				String custId = req.getParameter("custId");
				String routeId = req.getParameter("routeId");
				String status=req.getParameter("status");
				String startDateRange = req.getParameter("startDateRange");
				String endDateRange = req.getParameter("endDateRange");
				try{
					obj = new JSONObject();

						jArr =null;
						String  message = exp.dashCustExportData(systemId,clientId,offset,groupId,unit,userId,custId,routeId,status,startDateRange,endDateRange,zone);
						resp.getWriter().print(message);
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if (param.equals("getTripCustomerType")) {
				try {
					obj = new JSONObject();
					jArr = gf.getTripCustomerType(systemId,clientId);
					
					if (jArr.length() > 0) {
						obj.put("tripCustTypeRoot", jArr);
					} else {
						obj.put("tripCustTypeRoot", "");
					}
					
					resp.getWriter().print(obj.toString());
				
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			/***************************************************************************************************************************************************
			 * Gets Buffers for Map View
			 ***************************************************************************************************************************************************/
			if (param.equalsIgnoreCase("getBufferMapView")) {
				try {
					String tripId = req.getParameter("tripId");
					jArr = new JSONArray();
					obj = new JSONObject();
					jArr = gf.getMapViewBuffers(userId,clientId,systemId,zone,isLtsp,Integer.parseInt(tripId));
					if (jArr.length() > 0) {
						obj.put("BufferMapView", jArr);
					} else {
						obj.put("BufferMapView", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}
			
			/***************************************************************************************************************************************************
			 * Gets Polygon for Map View
			 ***************************************************************************************************************************************************/
			if (param.equalsIgnoreCase("getPolygonMapView")) {
				try {
					String tripId = req.getParameter("tripId");
					jArr = new JSONArray();
					obj = new JSONObject();
					jArr = gf.getMapViewPolygons(userId,clientId,systemId,zone,isLtsp,Integer.parseInt(tripId));
					if (jArr.length() > 0) {
						obj.put("PolygonMapView", jArr);
					} else {
						obj.put("PolygonMapView", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}
			
			else if(param.equals("getTripsForCustomer")){
				try {
					JSONObject jsonObject = new JSONObject();
					String tripCustId = req.getParameter("tripCustId");
					String startDate = req.getParameter("startDate");
					String endDate = req.getParameter("endDate");
					obj = new JSONObject();
					jArr = gf.getTripsForCustomer(systemId,clientId,offset,userId,tripCustId,startDate,endDate);
					if (jArr.length() > 0) {
						jsonObject.put("tripRoot", jArr);
					} else {
						jsonObject.put("tripRoot", "");
					}
					resp.getWriter().print(jsonObject.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "TCL History Report", "View", userId, serverName, systemId, clientId,
					"Visited This Page");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			else if(param.equals("getTrips")) {
				try {
					JSONObject jsonObject = new JSONObject();
					String tripIds = req.getParameter("tripIds");
					obj = new JSONObject();
					jArr = gf.getTrips(systemId,clientId,offset,userId,tripIds);
					if (jArr.length() > 0) {
						jsonObject.put("tripGridRoot", jArr);
					} else {
						jsonObject.put("tripGridRoot", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getVehicleWiseTemperatureReport")){
				try {
					JSONObject jsonObject = new JSONObject();
					String regNo = req.getParameter("vehicleNo");
					String startdate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("startdate")));
					String enddate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("enddate")));
					String hourlyData = req.getParameter("hourlyRange1");
					obj = new JSONObject();
					if(Integer.parseInt(hourlyData)==1){
					jArr = gf.getVehicleWiseTemperatureReport(systemId,clientId,offset,userId,startdate,enddate,regNo);
					}else{
					jArr = gf.getVehicleWiseTemperatureReportBasedOnTimeRange(systemId,clientId,offset,userId,startdate,enddate,regNo,hourlyData);	
					}
					if (jArr.length() > 0) {
						jsonObject.put("temperatureReportRoot", jArr);
					} else {
						jsonObject.put("temperatureReportRoot", "");
					}
					resp.getWriter().print(jsonObject.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Temperature Report Advanced", "View", userId, serverName, systemId, clientId,
					"Visited This Page");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("geofenceCorrectionAndOtherAlerts")){
				try{
					obj = new JSONObject();
					  jArr = gf.getgeofenceCorrectionAndOtherAlerts(systemId, clientId, userId, zone, isLtsp, offset);
						if(jArr.length() > 0){
							obj.put("geofenceCorrectionAndOtherAlertsAction", jArr);
						}else{
							obj.put("geofenceCorrectionAndOtherAlertsAction", "");
						}					
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			  }else if(param.equals("acknowlegdeGeofenceCorrection")){
					try{
						obj = new JSONObject();
						String tripId = req.getParameter("tripId");
						String remarks = req.getParameter("remarks");
						String id = req.getParameter("uniqueId");
						 
						String message = "";
						message = gf.updateGeofenceCorrection(Integer.parseInt(tripId),Integer.parseInt(id),userId, systemId, clientId,remarks);
						resp.getWriter().print(message);
					}catch(Exception e){
						e.printStackTrace();
					}
			}
			
			  else if(param.equals("getTripsWhoseATAIsToBeUpdated")){
					try{
						obj = new JSONObject();
						  jArr = gf.getTripsWhoseATAIsToBeUpdated(systemId,clientId,offset);				  
							if(jArr.length() > 0){
								obj.put("tripsWhoseATAIsToBeUpdated", jArr);
							}else{
								obj.put("tripsWhoseATAIsToBeUpdated", "");
							}					
						resp.getWriter().print(obj.toString());
					}catch(Exception e){
						e.printStackTrace();
					}
				  }
			
			else if (param.equals("updateATAForClosedTrip")) {
				try {
					String tripId = req.getParameter("tripId");
					String ata = req.getParameter("ata");

					String message = "";
					message = gf.updateATAForClosedTrip(tripId, ata, systemId, clientId, userId, offset, zone, logWriter);
					resp.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("createLegExcel")) {
				String path = "";
				String startDateRange = req.getParameter("startDateRange");
				String endDateRange = req.getParameter("endDateRange");
				String custType = req.getParameter("custType");
				String tripType = req.getParameter("tripType");
				String groupId =req.getParameter("groupId");
				String unit = req.getParameter("unit");
				String custId = req.getParameter("custId");
				String routeId = req.getParameter("routeId");
				String status = req.getParameter("status");
				try {
					path = gf.getLegDetaisReport(systemId, clientId, offset, groupId, unit, userId, custId, routeId, status,
							startDateRange, endDateRange, custType, tripType, zone);
					resp.getWriter().print(path);
				} catch (Exception e) {
					e.printStackTrace();
				}
	      }else if(param.equals("getVehicleTypeData")){
	    	  String custId = req.getParameter("custId");
	    	  String vehicleCatgry =  req.getParameter("vehicleCategry");
				try {
					obj = new JSONObject();
					if(custId != null && !custId.equals("")){
						jArr = creatTripFunc.getVehicleType(systemId,custId,vehicleCatgry);
						obj.put("vehicleTypeRoot", jArr);
					}else{
						obj.put("vehicleTypeRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getHubNames")){
		    	  try{
			    		jArr = gf.getDriverAssociatedHubNames(systemId,clientId,zone);
			    		obj = new JSONObject();
			    		if(jArr.length() > 0){
			    			obj.put("hubNamesRoot", jArr);
			    		}else{
			    			obj.put("hubNamesRoot", "");
			    		}
			    		resp.getWriter().print(obj.toString());
			    	  }catch(final Exception e){
			    		  e.printStackTrace();
			    	  }
					} else if (param.equals("getDriverNames")) {
						String hubIdList = req.getParameter("hubList");
						
						try {
							jArr = gf.getDriverNamesBasedOnHubSelected(hubIdList, clientId, zone);
							obj = new JSONObject();
							if (jArr.length() > 0) {
								obj.put("driverNamesRoot", jArr);
							} else {
								obj.put("driverNamesRoot", "");
							}
							resp.getWriter().print(obj.toString());
						} catch (final Exception e) {
							e.printStackTrace();
						}
					}else if(param.equals("getParticularDriverDetails")){
						try{
							int driverId = Integer.parseInt(req.getParameter("driverId") == null || "".equals(req.getParameter("driverId")) 
					            	|| "ALL".equalsIgnoreCase(req.getParameter("driverId")) ? "0" : req.getParameter("driverId"));
							String startDate = yyyyMMdd.format(ddmmyyyy1.parse(req.getParameter("startDate")));
				            String endDate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("endDate")+" 23:59:59"));
							obj = new JSONObject();
							jArr = gf.getDriverDetailsByDriverId(clientId,driverId,startDate,endDate,offset);
							if(jArr.length() > 0){
								obj.put("driverDetailsRoot", jArr);
							}else{
								obj.put("driverDetailsRoot", "");
							}
							resp.getWriter().print(jArr.toString());
						}catch(final Exception e){
							e.printStackTrace();
						}
					}else if(param.equals("updateRemarks")){
						String message = "";
						try{
							int driverId = Integer.parseInt(req.getParameter("driverId"));
							String driverName = req.getParameter("driverName");
							int hubId = Integer.parseInt(req.getParameter("hubId"));
							String hubName = req.getParameter("hubName");
							double score = Double.parseDouble(req.getParameter("score"));
							String remarks = req.getParameter("remarks");
							message = gf.updateTrainingRemarks(systemId,clientId,driverId,driverName,hubId,
									hubName,score,remarks,userId);
							resp.getWriter().print(message);
						}catch(final Exception e){
							e.printStackTrace();
						}
					}else if(param.equals("fetchTrainingRemarksDetails")){
						try{
							int driverId = Integer.parseInt(req.getParameter("driverId"));
							jArr = gf.fetchTrainingRemarksDetails(clientId,driverId);
							obj = new JSONObject();
							if(jArr.length() > 0){
								obj.put("trainingRemarksDetailsRoot", jArr);
							}else{
								obj.put("trainingRemarksDetailsRoot", "");
							}
							resp.getWriter().print(obj.toString());
						}catch(final Exception e){
							e.printStackTrace();
						}
					}
	  } catch(Exception e){
			e.printStackTrace();
	  }
	  return null;
	}
}

