package t4u.trip;

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

import com.google.gson.Gson;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.CommonFunctions;
import t4u.functions.CreateTripFunction;
import t4u.functions.LogWriter;

public class TripCreatAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        CommonFunctions cf=new CommonFunctions();
        SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd");
    	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    	SimpleDateFormat sdfLog = new SimpleDateFormat("dd-MM-yyyy");
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        int custId1= loginInfo.getCustomerId();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        String serverName = request.getServerName();
        String sessionId = request.getSession().getId();
        CreateTripFunction creatTripFunc = new CreateTripFunction();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
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
				logWriter = new LogWriter("Inside TripCreatAction " +"param : "+param+ "-- " + session.getId() + "--" + userId,LogWriter.INFO, pw);
				logWriter.setPrintWriter(pw);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if(param.equals("getCustomer")){
			try {
				jsonObject = new JSONObject();
				jsonArray = creatTripFunc.getCustomer(custId1, systemId);
				jsonObject.put("customerRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
        else if(param.equals("getRouteNames")){
			try {
				String custIdSelected=request.getParameter("custId");
				String legConcept=request.getParameter("legConcept");
				String hubAssociatedRoutes=request.getParameter("hubAssociatedRoutes");
				jsonObject = new JSONObject();
				if (custIdSelected != null && !custIdSelected.equals("")) {
					jsonArray = creatTripFunc.getRoutenames(Integer.parseInt(custIdSelected), systemId, custId1, userId, legConcept,hubAssociatedRoutes);
					jsonObject.put("RouteNameRoot", jsonArray);
				} else {
					jsonObject.put("RouteNameRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "Quick Trip Planner", "View", userId, serverName, systemId, custId1,
				"Visited This Page");
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		else if (param.equals("getvehiclesandgroupforclients")) {
			try {
				jsonObject = new JSONObject();
				String productLine=request.getParameter("productLine");	
				String vehicleReporting=request.getParameter("vehicleReporting");
				String date=request.getParameter("date");
				String formattedDate = sdfDB.format(sdf.parse(date));
				
				jsonArray = creatTripFunc.getVehiclesAndGroupForClient(systemId,custId1, userId,productLine,vehicleReporting,formattedDate);
				jsonObject.put("clientVehicles", jsonArray);
				response.getWriter().print(jsonObject.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getTripDetails")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String startDate = request.getParameter("startdate");
	            String endDate = request.getParameter("enddate")+" "+ "23:59:59";
	            String statusType = request.getParameter("statusType");
	            String vehicleNo = request.getParameter("regno");
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	            	startDate = startDate.replaceAll("T", " ");
	            	endDate = endDate.replaceAll("T", " ");
	            	ArrayList < Object > list1 = new ArrayList<Object>();
	            	if(systemId == 268){
	            		list1 = creatTripFunc.getTripDetailsDHL(systemId, Integer.parseInt(customerId),startDate,endDate,offset,userId,sessionId,serverName,statusType,vehicleNo);
	            	}else{
	            		list1 = creatTripFunc.getTripDetails(systemId, Integer.parseInt(customerId),startDate,endDate,offset,userId,sessionId,serverName,statusType);
	            	}
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("ticketDetailsRoot",jsonArray);
	                } else {
	                    jsonObject.put("ticketDetailsRoot", "");
	                }
	               // reportHelper = (ReportHelper) list1.get(1);
//	             	request.getSession().setAttribute(jspName, reportHelper);
//	             	request.getSession().setAttribute("customerId", custName);
	             	response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("ticketDetailsRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		else if (param.equals("cancelTrip")) {
			try {
				logWriter.log("Start of TripCreatAction.cancelTrip method :"+sessionId +"::Trip Id:"+request.getParameter("uniqueId"),LogWriter.INFO);
				String uniqueId=request.getParameter("uniqueId");
				String vehicleNo = request.getParameter("vehicleNo");
				String remarks = request.getParameter("remarks");			
				String reasonId = request.getParameter("reasonId");
				String status = request.getParameter("status");
				String message="";
				
				message = creatTripFunc.cancelTrip(userId,Integer.parseInt(uniqueId),sessionId,serverName,userId,systemId,custId1,
						vehicleNo,remarks,logWriter,reasonId,offset,status);
				logWriter.log("End of TripCreatAction.cancelTrip method :"+sessionId ,LogWriter.INFO);
				response.getWriter().print(message);
			}

			catch (Exception e) {
				logWriter.log("Error in TripCreatAction.cancelTrip method :"+sessionId + e.getMessage() ,LogWriter.ERROR);
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("saveTripData")) {
	        try {
	        	logWriter.log(" Start of the TripCreatAction.saveTripData method "+sessionId, LogWriter.INFO);
	            String custId = request.getParameter("CustId");
	            String routeId=request.getParameter("routeId");
	            String routeName=request.getParameter("routeName");
                String vehicleNo=request.getParameter("vehicleNo");
             	String plannedDate=request.getParameter("plannedDate");
             	String addcustomerName=request.getParameter("addcustomerName");
             	String customerName=request.getParameter("customerName");
             	String custReference=request.getParameter("custReference");
             	String filePath=request.getParameter("filePath");
             	String viewFlag=request.getParameter("viewFlag");
             	String startDate=request.getParameter("startDate");
             	String endDate=request.getParameter("endDate");
             	String minHumidity=request.getParameter("minHumidity");
             	String maxHumidity=request.getParameter("maxHumidity");
             	String tempeartureArray=request.getParameter("tempeartureArray");
             	String selSensorsToAlertTrigger=request.getParameter("selSensorsToAlertTrigger");
             	//String maxTemp=request.getParameter("maxTemp");
             	StringBuffer alertId=new StringBuffer(request.getParameter("alertId"));
                alertId.append("58,106,45,3,7,182,174,186,187,188,189,190,196,93");
                String alert= new String(alertId);
                String avgSpeed = request.getParameter("avgSpeed");
	            String message1="";
	            String successMessage="";
	            String tripId="";
	            String [] message;
	            String peLoadTemp = request.getParameter("peLoadTemp");
	            String recordsCount = request.getParameter("recordsCount");
	            String drivers = request.getParameter("drivers");
	            String date = request.getParameter("date");
	            String legId = request.getParameter("legId");
	            String productLine = request.getParameter("productLine");
	            String category = request.getParameter("category");
	            String tripCustId = request.getParameter("tripCustId");
	            String sealNo = request.getParameter("sealNo");
	            int routeTemplateId = 0;
	            int noOfBags = 0;
	            if(!request.getParameter("noOfBags").equals("")){
	            	noOfBags=Integer.parseInt(request.getParameter("noOfBags"));
	            }
	            String tripType = request.getParameter("tripType");
	            int noOfFluidBags = 0;
	            if(!request.getParameter("noOfFluidBags").equals("") ){
	            	noOfFluidBags=Integer.parseInt(request.getParameter("noOfFluidBags"));
	            }
	            float openingKms=0;
	            if(!request.getParameter("openingKms").equals("")){
	            	openingKms=Float.parseFloat(request.getParameter("openingKms"));
	            }
	            String tripRemarks = request.getParameter("tripRemarks");
	            int materialId = 0;
	            // For NTC requirement
	            
	            String materialClient = (request.getParameter("materialClient")!=null)? request.getParameter("materialClient"):"";
	            if("Y".equals(materialClient)){
	            	routeTemplateId = (request.getParameter("routeTemplateId") != null)?Integer.parseInt(request.getParameter("routeTemplateId")):0;
	            	productLine = "Dry";
	            	materialId = (request.getParameter("materialId") != null)?Integer.parseInt(request.getParameter("materialId")):0;
	            }
	            if (custId != null && !custId.equals("")) {
			              message1 = creatTripFunc.addTripDetails(systemId,Integer.parseInt(custId),userId,Integer.parseInt(routeId),vehicleNo,plannedDate,alert,routeName,offset,
			            		  addcustomerName,custReference,avgSpeed,tempeartureArray,selSensorsToAlertTrigger,minHumidity,maxHumidity,peLoadTemp,recordsCount,drivers,date,legId,
			            		  productLine,tripCustId,sessionId,serverName,sealNo,noOfBags,tripType,noOfFluidBags,openingKms,tripRemarks,routeTemplateId,materialId,logWriter,category,customerName);
	            }
	            if(!message1.equals("") && !message1.equals(null)){
	            	if(message1.contains(",")){	
	            	message=message1.split(",");
	            		successMessage = message[0];
	            		tripId=message[1];
	            	}
	            	else{
	            		successMessage=message1;
	            	}
	            }
	            //RequestDispatcher rd = getServletContext().getRequestDispatcher("/UploadCreateTripImage?tripId="+tripId+"&filePath="+filePath);
	            session.setAttribute("tripId", tripId);
	            session.setAttribute("filePath", filePath);
	            session.setAttribute("startDate", startDate);
	            session.setAttribute("endDate", endDate);
	            if (viewFlag != null && !viewFlag.equals("")) {
	            	session.setAttribute("viewFlag", viewFlag);
	            }
	            logWriter.log(" End of TripCreatAction.saveTripData method "+sessionId+"::message:"+message1, LogWriter.INFO);
	            response.getWriter().print(successMessage);
	        } catch (Exception e) {
	        	logWriter.log(" Error in TripCreatAction.saveTripData method "+sessionId+ e.getMessage(), LogWriter.ERROR);
	            e.printStackTrace();
	        }
	    }
		else if (param.equalsIgnoreCase("modifyTripData")) {
	        try {
	        	logWriter.log("Start of TripCreateAction.modifyTripData method "+sessionId, LogWriter.INFO);
	            String custId = request.getParameter("CustId");
             	String plannedDate=request.getParameter("plannedDate");
             	String tripId=request.getParameter("tripId");
             	String preLoadTemp = request.getParameter("preLoadTemp");
	            String recordsCount = request.getParameter("recordsCount");
	            String drivers = request.getParameter("drivers");
	            String date = request.getParameter("dates");
	            String legId = request.getParameter("legId");
	            String modifyAvgSpeed = request.getParameter("modifyAvgSpeed");
	            String vehicleNo = request.getParameter("vehicleNo");
	            String routeId = request.getParameter("routeId");
	            String custRefId = request.getParameter("custRefId");
	            String category = request.getParameter("category");
	            String productLine = request.getParameter("productLine");
	            String routeName = request.getParameter("routeName");
	            String tempData = request.getParameter("modTempeartureData");
	            String selSensorsToAlertTrigger=request.getParameter("selSensorsToAlertTrigger");
//	            String sealNo = request.getParameter("modSealNo");
//	            int noOfBags = 0;
//	            if(!request.getParameter("modNoOfBags").equals("")){
//	            	noOfBags=Integer.parseInt(request.getParameter("modNoOfBags"));
//	            }
//	            String tripType = request.getParameter("modTripType");
//	            int noOfFluidBags = 0;
//	            if(!request.getParameter("modNoOfFluidBags").equals("") ){
//	            	noOfFluidBags=Integer.parseInt(request.getParameter("modNoOfFluidBags"));
//	            }
//	            float openingKms=0;
//	            if(!request.getParameter("modOpeningKms").equals("")){
//	            	openingKms=Float.parseFloat(request.getParameter("modOpeningKms"));
//	            }
//	            String tripRemarks = request.getParameter("modTripRemarks");
	            
	            String message="";
	            if (custId != null && !custId.equals("")) {
	            	
			              message = creatTripFunc.modifyTripDetails(systemId,Integer.parseInt(custId),userId,plannedDate,offset,
			            		  Integer.parseInt(tripId),preLoadTemp,recordsCount,drivers,date,legId,sessionId,serverName,modifyAvgSpeed,logWriter,vehicleNo,routeId,custRefId,category,productLine,routeName,tempData,selSensorsToAlertTrigger);
			            		  //sealNo,noOfBags,tripType,noOfFluidBags,openingKms,tripRemarks);
	            }
	            logWriter.log(" End of the TripCreatAction.modifyTripDetails method "+sessionId, LogWriter.INFO);
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	            logWriter.log(" Error in TripCreatAction.modifyTripDetails method "+sessionId+e.getMessage(), LogWriter.ERROR);
	        }
	    }
		//#############################TripSummaryReport#########################
		if (param.equalsIgnoreCase("getTripSummaryReport")) {
	   	     try {
	   	         String customerId = request.getParameter("CustId");
	   	         String startdate=request.getParameter("startdate");
	   	         String enddate=request.getParameter("enddate");
	   	         String jspName=request.getParameter("jspName");
	   	         String custName=request.getParameter("custName");
	   	         jsonArray = new JSONArray();
	   	         if(startdate.contains("T") && enddate.contains("T")){
		       	    	startdate=startdate.replace("T", " ");
		       	    	enddate=enddate.replace("T", " ");
		   	         }
	  	         if (customerId != null && !customerId.equals("")) {
	   	             ArrayList < Object > list1 = creatTripFunc.getTripSummaryReportNew(Integer.parseInt(customerId), systemId,offset,startdate,enddate,lang);
	   	             jsonArray = (JSONArray) list1.get(0);
	   	             if (jsonArray.length() > 0) {
	   	                 jsonObject.put("tripSummaryRoot", jsonArray);
	   	             } else {
	   	                 jsonObject.put("tripSummaryRoot", "");
	   	             }
	   	            ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startdate",ddmmyyyy.format(yyyymmdd.parse(startdate)));
					request.getSession().setAttribute("enddate",ddmmyyyy.format(yyyymmdd.parse(enddate)));
					request.getSession().setAttribute("custId", custName);
	   	         } else {
	   	             jsonObject.put("tripSummaryRoot", "");
	   	         }
	   	      response.getWriter().print(jsonObject.toString());
	   	     } catch (Exception e) {
	   	         e.printStackTrace();
	   	     }
	   	 } 

		else if (param.equals("closeTripAmazon")) {
			try {
				String status=request.getParameter("status");
				String uniqueId=request.getParameter("uniqueId");
				String message="";
				
				message = creatTripFunc.closeTrip(systemId,custId1, userId,Integer.parseInt(uniqueId),status);
				
				 response.getWriter().print(message);
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(param.equals("getRouteDetails")){
			try {
				//String clientIdSelected=request.getParameter("CustId");
				String routeId=request.getParameter("RouteId");
				jsonObject = new JSONObject();
				if (routeId != null && !routeId.equals("")) {
					jsonArray = creatTripFunc.getRouteDetails( systemId, routeId);//Integer.parseInt(clientIdSelected),
					jsonObject.put("RouteDataRoot", jsonArray);
				} else {
					jsonObject.put("RouteDataRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		} 

		else if(param.equals("getLegDetails")){
			String routeId = request.getParameter("routeId");
			String date = request.getParameter("date");
			try {
				jsonObject = new JSONObject();
				if(routeId != null && !routeId.equals("") && date != null && !date.equals(":00")){
					jsonArray = creatTripFunc.getLegDetails( systemId,custId1,routeId,date);
					jsonObject.put("legDetailsRoot", jsonArray);
				}else{
					jsonObject.put("legDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}else if(param.equals("getDriverList")){
			int tripId = 0;
			if(request.getParameter("tripId") != null && !request.getParameter("tripId").equals("")){
				tripId = Integer.parseInt(request.getParameter("tripId"));
			}
			try {
				jsonObject = new JSONObject();
				jsonArray = creatTripFunc.getDriverDetails( systemId,custId1,tripId);
				jsonObject.put("driverDetailsRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getTripLegDetails")){
			String tripId = request.getParameter("tripId");
			try {
				jsonObject = new JSONObject();
				if(tripId != null && !tripId.equals("")){
					jsonArray = creatTripFunc.getTripLegDetails( systemId,custId1,tripId,offset);
					jsonObject.put("tripLegDetailsRoot", jsonArray);
				}else{
					jsonObject.put("tripLegDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getProductLine")){
			String custId = request.getParameter("custId");
			try {
				jsonObject = new JSONObject();
				if(custId != null && !custId.equals("")){
					jsonArray = creatTripFunc.getProductLine(systemId,custId);
					jsonObject.put("productLineRoot", jsonArray);
				}else{
					jsonObject.put("productLineRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getCategory")){
			String custId = request.getParameter("custId");
			try {
				jsonObject = new JSONObject();
				if(custId != null && !custId.equals("")){
					jsonArray = creatTripFunc.getCategory(systemId,custId);
					jsonObject.put("categoryRoot", jsonArray);
				}else{
					jsonObject.put("categoryRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getUserAssociatedCustomer")){
			try {
				String loggedInUserId=request.getParameter("userId");
				String userAuthority=request.getParameter("userAuth");
				String custId=request.getParameter("custId");
				jsonObject = new JSONObject();
				if (loggedInUserId != null && !loggedInUserId.equals("")) {
					jsonArray = creatTripFunc.getUserAssociatedCustomer(Integer.parseInt(loggedInUserId), systemId,userAuthority,custId);
					jsonObject.put("customerRoot", jsonArray);
				} else {
					jsonObject.put("customerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("closeTrip")) {
			try {
				logWriter.log("Start of TripCreateAction.CloseTrip method "+sessionId, LogWriter.INFO);
				String uniqueId=request.getParameter("uniqueId");
				String vehicleNo = request.getParameter("vehicleNo");
				String remarksData = request.getParameter("remarksData");
				String ata = request.getParameter("ata");
				boolean destinationArrived = new Boolean(request.getParameter("destinationArrived"));
				String shipmentId = request.getParameter("shipmentId");
				String status = request.getParameter("status");
				String lrNo = request.getParameter("lrNo");
				String atp = request.getParameter("atp");
				String atd = request.getParameter("atd");
				boolean atpChanged = Boolean.parseBoolean(request.getParameter("atpChanged"));
				boolean atdChanged = Boolean.parseBoolean(request.getParameter("atdChanged"));
				boolean ataChanged = Boolean.parseBoolean(request.getParameter("ataChanged"));
				
				String message="";
				//validate - if user has permission to override ATA , then ATA should not be less than latest leg/checkpoint departure time.
				if(systemId == 268){
					
					logWriter.log("TripCreateAction.closeTrip : ATA is valid"+sessionId,LogWriter.INFO);
					message = creatTripFunc.closeRunningTrip(userId,Integer.parseInt(uniqueId),systemId,custId1,offset,sessionId,serverName,
							vehicleNo,remarksData,ata,destinationArrived,logWriter,shipmentId,status,lrNo,atp,atd,atpChanged,atdChanged,
							ataChanged);
				}else{
					message = creatTripFunc.closeTripForHardCodedValues(userId,remarksData,Integer.parseInt(uniqueId),shipmentId,offset,vehicleNo,systemId,custId1,
							logWriter,sessionId,serverName);
				}
				logWriter.log("End of TripCreateAction.closeTrip method :"+sessionId + message ,LogWriter.INFO);
				response.getWriter().print(message);
			}
			catch (Exception e) {
				logWriter.log("Error in TripCreateAction.closeTrip method :"+sessionId+e.getMessage() ,LogWriter.ERROR);
				e.printStackTrace();
			}
		}else if(param.equals("getAvailableRoutes")){
			String routeId = request.getParameter("routeId");
			String tripId = request.getParameter("tripId");
			String tripCustId = request.getParameter("tripCustId");
			try{
				jsonObject = new JSONObject();
				jsonArray = creatTripFunc.getAvailableRoutes(systemId,custId1,tripId,routeId,tripCustId);
				if(jsonArray.length() > 0){
					jsonObject.put("changesRouteRoot", jsonArray);
				}else{
					jsonObject.put("changesRouteRoot", "");
				}
				response.getWriter().println(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("checkLegEnded")){
			String tripId = request.getParameter("tripId");
			String message="";
			try {
				message = creatTripFunc.checkLegEndedOrNot(tripId);
				response.getWriter().print(message);
			}catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("changeRoute")){
			logWriter.log("Start of TripCreateAction.changeRoute method "+sessionId, LogWriter.INFO);
			String oldRouteId = request.getParameter("oldRouteId");
			String tripId = request.getParameter("tripId");
			String tripCustId = request.getParameter("tripCustId");
			String newRouteId = request.getParameter("newRouteId");
			String routeName = request.getParameter("routeName");
			String message = "";
			try {
				message = creatTripFunc.changeRoute(systemId,custId1,tripId,tripCustId,oldRouteId,newRouteId,userId,routeName);
				logWriter.log("End of TripCreateAction.changeRoute method "+sessionId+"::message:"+message, LogWriter.INFO);
				response.getWriter().print(message);
			}catch (Exception e) {
				e.printStackTrace();
				logWriter.log("Error in TripCreateAction.changeRoute method "+sessionId+e.getMessage(), LogWriter.INFO);
			}
		}	
//		else if (param.equals("getvehiclesFromVehicleReporting")) {
//			try {
//				jsonObject = new JSONObject();
//				String productLine="";
//				String vehicleReporting=request.getParameter("vehicleReporting");
//				String date=request.getParameter("date");
//				jsonArray = creatTripFunc.getVehiclesAndGroupForClient(systemId,custId1, userId,productLine,vehicleReporting,date);
//				jsonObject.put("clientVehicles", jsonArray);
//				response.getWriter().print(jsonObject.toString());
//			}
//			catch (Exception e) {
//				e.printStackTrace();
//			}
//		}
		
		else if (param.equals("saveSwappedVehicleDetails")) {
			try {
				logWriter.log("Start of TripCreateAction.saveSwappedVehicleDetails method "+sessionId, LogWriter.INFO);
	        	String tripId=request.getParameter("tripId");
				String oldVehicleNo=request.getParameter("oldVehicleNo");
				String newVehicleNo=request.getParameter("newVehicleNo");
				String message = "";
				if(oldVehicleNo == null || oldVehicleNo.equals("")){
					message = "Invalid vehicle number";
				}
				
				else if(newVehicleNo == null || newVehicleNo.equals("")){
					message = "Invalid vehicle number";
				}else{
					String vehicleSwapRemarks=request.getParameter("vehicleSwapRemarks");
					message = creatTripFunc.saveSwappedVehicleDetails(userId,tripId,oldVehicleNo,newVehicleNo,vehicleSwapRemarks,logWriter,sessionId);
				}
				logWriter.log("End of TripCreateAction.saveSwappedVehicleDetails method "+message, LogWriter.INFO);
				response.getWriter().print(message);
			}
			catch (Exception e) {
				logWriter.log("Error in TripCreateAction.saveSwappedVehicleDetails method "+sessionId+e.getMessage(), LogWriter.INFO);
				e.printStackTrace();
			}
		}else if (param.equals("getTripScheduleAndActualTime")) {
			try {
				String customerId = request.getParameter("CustId");
	            String startDate = request.getParameter("startdate");
	            String endDate = request.getParameter("enddate")+" "+ "23:59:59";
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	            	startDate = startDate.replaceAll("T", " ");
	            	endDate = endDate.replaceAll("T", " ");
	                ArrayList < Object > list1 = creatTripFunc.getTripScheduleAndActualTime(systemId, Integer.parseInt(customerId),startDate,endDate,offset,userId);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("tripDetails",jsonArray);
	                } else {
	                    jsonObject.put("tripDetails", "");
	                }
	             	response.getWriter().print(jsonObject.toString());
	            }
			}
		
			
			catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("updateTripActualTime")) {
			try {
				logWriter.log("Start of TripCreateAction.updateTripActualTime method "+sessionId, LogWriter.INFO);
				String tripId = request.getParameter("tripId");
	            String atp = request.getParameter("atp");
	            String atd = request.getParameter("atd");
	            String std = request.getParameter("std");
	            String remarks = request.getParameter("remarks");
	            String vehicleNo = request.getParameter("vehicleNo");
				String result = "";
				String ata = request.getParameter("ata");
				boolean atpChanged = Boolean.parseBoolean(request.getParameter("atpChanged"));
				boolean atdChanged = Boolean.parseBoolean(request.getParameter("atdChanged"));
				boolean ataChanged = Boolean.parseBoolean(request.getParameter("ataChanged"));
				
				result = creatTripFunc.updateTripActualTime(atp, atd, std,offset,systemId,custId1,vehicleNo,Integer.parseInt(tripId),remarks,userId,
						logWriter,sessionId,serverName,ata,atpChanged,atdChanged,ataChanged);
				
				logWriter.log("End of TripCreatAction.updateTripActualTime method "+sessionId + result, LogWriter.INFO);
				response.getWriter().print(result);
			}
			catch (Exception e) {
				logWriter.log("Error in TripCreatAction.updateTripActualTime method "+sessionId + e.getMessage(), LogWriter.INFO);
				e.printStackTrace();
			}
		}else if (param.equals("validateTripLRNo")) {
			try {

	        	String lrNo=request.getParameter("lrNo");
	        	String tripCustomerId = request.getParameter("tripCustomerId");
				
				String message = creatTripFunc.validateTripLRNo(lrNo,systemId,custId1,tripCustomerId);
				response.getWriter().print(message);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getTempConfigurationsByVehicleNo"))
		{			
				String regNo = request.getParameter("vehicleNo");
				String productLine = request.getParameter("productLine");
				jsonArray = new JSONArray();
				try {
					JSONObject obj = new JSONObject();
					if (productLine.equalsIgnoreCase("Dry")){
						obj.put("tempConfigurationsByVehicleNoDetails", "");
					}else{
						jsonArray = creatTripFunc.getTempConfigurationsByVehicleNo(systemId, custId1, regNo);

						if (jsonArray.length() > 0) {
							obj.put("tempConfigurationsByVehicleNoDetails", jsonArray);
						} else {
							obj.put("tempConfigurationsByVehicleNoDetails", "");
						}
						
				}
					response.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTripCancellationRemarks"))
			{			
				jsonArray = new JSONArray();
				try {
					JSONObject obj = new JSONObject();
					
						jsonArray = creatTripFunc.getTripCancellationRemarks(systemId);

						if (jsonArray.length() > 0) {
							obj.put("remarks", jsonArray);
						} else {
							obj.put("remarks", "");
						}
						
				
					response.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getExistingTempConfigurations"))
			{			
				String tripId =  request.getParameter("tripId");
				String vehicleNo = request.getParameter("vehicleNo");
				jsonArray = new JSONArray();
				try {
					JSONObject obj = new JSONObject();
						jsonArray = creatTripFunc.getExistingTempConfigurationsForVehicleNo(systemId, custId1,tripId,vehicleNo);

						if (jsonArray.length() > 0) {
							obj.put("tempConfigurationsByVehicleNoDetails", jsonArray);
						} else {
							obj.put("tempConfigurationsByVehicleNoDetails", "");
						}
						
					response.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("getAvailableVehicles")) {
				try {
					jsonObject = new JSONObject();
					String productLine=request.getParameter("productLine");	
					
					jsonArray = creatTripFunc.getAvailableVehicles(systemId,custId1, userId,productLine);
					jsonObject.put("clientVehicles", jsonArray);
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getCustomerNames")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = creatTripFunc.getCustomerNames(custId1, systemId);
				jsonObject.put("customerRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getTripCustomerNames")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = creatTripFunc.getTripCustomerNames(custId1, systemId);
				jsonObject.put("customerRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equalsIgnoreCase("getColumnSetting")) {
			String pageName = request.getParameter("pageName");
			String custArr = request.getParameter("custArr");
			try{
				jsonObject = new JSONObject();
				jsonArray = creatTripFunc.getColumnSetting(systemId,custArr,userId, pageName,custId1);
				if(jsonArray.length() > 0){
					jsonObject.put("columnSettingsRoot", jsonArray);
				}else{
					jsonObject.put("columnSettingsRoot", "");
				}
				//System.out.println(jsonObject.toString());
				response.getWriter().print(jsonObject.toString());	
			}catch (Exception e) {
				e.printStackTrace();
			}
	}
		else if (param.equalsIgnoreCase("updateColumnSetting")) {
			String columnSettings = request.getParameter("columnSettings");
			String custArr = request.getParameter("custArr");
			String pageName = request.getParameter("pageName");
				try{
					jsonObject = new JSONObject();
					Gson g = new Gson(); 
					List settingsList = g.fromJson(columnSettings, List.class); 
					creatTripFunc.updateColumnSetting(systemId, custArr, userId, settingsList,pageName,custId1);
					
					response.getWriter().print(jsonObject.toString());	
				}catch (Exception e) {
					e.printStackTrace();
				}
			}
		else if (param.equalsIgnoreCase("createColumnSettings")) {
			String columnSettings = request.getParameter("columnSettings");
			System.out.println(""+columnSettings);
			String pageName = request.getParameter("pageName");
			String custArr = request.getParameter("custArr");
				try{
					jsonObject = new JSONObject();
					Gson g = new Gson(); 
					List settingsList = g.fromJson(columnSettings, List.class);
					creatTripFunc.insertColumnSetting(systemId, custArr, userId, settingsList, pageName,custId1);
					
					response.getWriter().print(jsonObject.toString());	
				}catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("getTripsWhoseActualsAreEmpty")) {
			String userAuthority = request.getParameter("userAuthority");
			String startDate = request.getParameter("startDate")+" 00:00:00";
			String endDate = request.getParameter("endDate")+" 23:59:59";
			try {
				jsonObject = new JSONObject();
				jsonArray = creatTripFunc.getTripsWithoutActuals(systemId, custId1, offset, userAuthority,startDate,endDate);
				if (jsonArray.length() > 0) {
					jsonObject.put("getTripsWhoseActualsAreEmptyRoot", jsonArray);
				} else {
					jsonObject.put("getTripsWhoseActualsAreEmptyRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("updateActuals")) {
			try {
				String tripId = request.getParameter("tripId");
				String vehicleNo = request.getParameter("vehicleNo");
				String ata = request.getParameter("ata");
				String atp = request.getParameter("atp");
				String atd = request.getParameter("atd");
				String tripEndTime = request.getParameter("tripEndTime");
				boolean atpChanged = Boolean.parseBoolean(request.getParameter("atpChanged"));
				boolean atdChanged = Boolean.parseBoolean(request.getParameter("atdChanged"));
				boolean ataChanged = Boolean.parseBoolean(request.getParameter("ataChanged"));
				boolean tripEndTimeChanged = Boolean.parseBoolean(request.getParameter("tripEndTimeChanged"));
				String message = "";
				
				message = creatTripFunc.updateActuals(userId, Integer.parseInt(tripId), systemId, custId1, offset,
						 vehicleNo, ata, logWriter,atp, atd, tripEndTime,atpChanged,atdChanged,ataChanged,tripEndTimeChanged,serverName);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("checkATAisValid")){
			String date = "";
			try{
				String tripId = request.getParameter("tripId");
				String ata = request.getParameter("ata");
				
				date = creatTripFunc.checkIsATAValid(Integer.parseInt(tripId), ata, offset);
			}catch(final Exception e){
				e.printStackTrace();
			}
			response.getWriter().print(date.trim());
		}
		return null;
	}
}	


