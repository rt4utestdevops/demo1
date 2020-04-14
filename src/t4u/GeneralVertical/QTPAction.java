package t4u.GeneralVertical;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
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
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.CreateLandmarkFunctions;
import t4u.functions.CreateTripFunction;
import t4u.functions.GeneralVerticalFunctions;
import t4u.functions.LogWriter;

@SuppressWarnings("unused")
public class QTPAction extends Action {
	 
	GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
	CreateTripFunction ctf = new CreateTripFunction();
	CreateLandmarkFunctions createLandmarkFunctions = new CreateLandmarkFunctions();
	AdminFunctions af = new AdminFunctions();
	CommonFunctions cf = new CommonFunctions();
	CreateRoute cr = new CreateRoute();
	
	public ActionForward execute(ActionMapping map, ActionForm form,
			HttpServletRequest req, HttpServletResponse resp) {
		try {
			HttpSession session = req.getSession();

			String serverName = req.getServerName();
			String sessionId = req.getSession().getId();
			LoginInfoBean loginInfo = (LoginInfoBean) session
					.getAttribute("loginInfoDetails");
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddmmyyyy = new SimpleDateFormat(
					"dd/MM/yyyy HH:mm:ss");
			SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd/MM/yyyy");
			int systemId = 0;

			int clientId = 0;
			int offset = 0;
			int userId = 0;
			int isLtsp = 0;
			int nonCommHrs = 0;
			String lang = "";
			String zone = "";
			if (loginInfo != null) {
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
			if (req.getParameter("param") != null) {
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			
			SimpleDateFormat sdfLog = new SimpleDateFormat("dd-MM-yyyy");
	        LogWriter logWriter = null;
			Properties properties = ApplicationListener.prop;
			String logFile = properties.getProperty("LogFileForTripCreation");
			String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
			String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
			logFile = "QTP - "+logFileName + "-" + sdfLog.format(new Date()) + "." + logFileExt;
			PrintWriter pw;
			if (logFile != null) {
				try {
					pw = new PrintWriter(new FileWriter(logFile, true), true);
					logWriter = new LogWriter("Inside TripCreatAction " +"param : "+param+ "-- " + session.getId() + "--" + userId,LogWriter.INFO, pw);
					logWriter.setPrintWriter(pw);
				} catch (IOException e) {
					logWriter = new LogWriter("Can't open the log file: " + logFile + ". Using System.err instead",LogWriter.ERROR);
				}
			}

			 if (param.equals("getTripCustomers")) {
				String custId = req.getParameter("custId");
				String type = req.getParameter("type");
				try {
					obj = new JSONObject();
					jArr = gf.getTripCustomers(systemId, custId, type);
					if (jArr.length() > 0) {
						obj.put("customersRoot", jArr);
					} else {
						obj.put("customersRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("getCustomerType")) {
				String custId = req.getParameter("custId");
				try {
					obj = new JSONObject();
					jArr = gf.getCustomerType(systemId, custId);
					if (jArr.length() > 0) {
						obj.put("customerTypeRoot", jArr);
					} else {
						obj.put("customerTypeRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (param.equals("generateRouteID")) {
				String custId = req.getParameter("custId");
				String routeKey = req.getParameter("routeKey");
				String TAT = req.getParameter("TAT");

				String sourceHub = req.getParameter("sourceHub");
				String destHub = req.getParameter("destHub");

				String sourceCity = req.getParameter("sourceCity");
				String destCity = req.getParameter("destCity");
				
				String sourceType = req.getParameter("sourceCityType");
				String destinationType = req.getParameter("destCityType");
				
				String touchPointArray = req.getParameter("touchPointArray");
				String tripCustId = req.getParameter("tripCustId");
				
				String[] touchPointJs = null;
				if(touchPointArray.length()>2) {
					touchPointArray = touchPointArray.substring(1,touchPointArray.length()-2);
					touchPointJs = touchPointArray.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
				}
				try {
					obj = new JSONObject();
					jArr = gf.generateRouteID(systemId, custId, routeKey, TAT, sourceCity, destCity, touchPointJs, tripCustId,sourceHub,destHub,sourceType,destinationType,zone);
					if (jArr.length() > 0) {
						obj.put("routeIdRoot", jArr);
					} else {
						obj.put("routeIdRoot", "");
					}
					resp.getWriter().print(obj);
				} catch (Exception e) { 
					e.printStackTrace();
				}
			} 
			else if(param.equals("saveRoute")){
				double converfactor = cf.getUnitOfMeasureConvertionsfactor(systemId);
				obj = new JSONObject();
				String message= "";
				try {
					String hubDetails = req.getParameter("hubDetails");
					String routeDetails = req.getParameter("routeDetails");
					String legDetails = req.getParameter("legDetails");
					
					JSONArray hubjs=null;
					List<JSONObject> sortedList = new ArrayList<JSONObject>();
					List<String> hubList = new ArrayList<String>();
					
					JSONObject routeObj = null;
					if (routeDetails != null) {
						routeObj = new JSONObject(routeDetails.toString());
					}
					String avgSpeed = routeObj.getString("avgSpeed");
					String routeName[] = routeObj.getString("routeName").split("_");
					
					if (hubDetails != null) {
						hubjs = new JSONArray(hubDetails.toString());
					}
					for(int s= 0;s < hubjs.length();s++) {
						sortedList.add(hubjs.getJSONObject(s));
					}
					Collections.sort(sortedList, new Comparator<JSONObject>() {
						public int compare(JSONObject jsonObjectA, JSONObject jsonObjectB) {
							int compare = 0;
							try {
								int keyA = jsonObjectA.getInt("sequence");
								int keyB = jsonObjectB.getInt("sequence");
								compare = Integer.compare(keyA, keyB);
							} catch (JSONException e) {
								e.printStackTrace();
							}
							return compare;
						}
					});
					boolean flag = true;
					for(int h= 0;h < sortedList.size();h++) {
						JSONObject object = sortedList.get(h);
						String hubId = "";
						String geoType = "";
						if(Integer.parseInt(object.getString("hubId")) > 0) {
							hubId = object.getString("hubId");
							geoType = object.getString("type");
						} else {
							geoType = object.getString("geofenceType");
							String[] hubIds = cr.saveHub(systemId, userId, sessionId, serverName, isLtsp, object, clientId, converfactor,routeName[h+2],zone);
							hubId = hubIds[1];
							message = hubIds[0];
							if(!hubIds[0].equals("<p class='successmessage'>Location Saved Successfully</p>")) {
								flag = false;
								break;
							}
						}
						hubList.add(hubId + "_" + geoType);
					}
					if(flag) {
						JSONObject legobj = cr.saveLegDetails(legDetails, systemId, userId, sessionId, serverName, clientId,avgSpeed,hubList,zone);
						String[] legIds = (String[]) legobj.get("legIds");
						System.out.println(legIds.length);
						String tripCustId = (String) legobj.get("tripCustId");
						JSONObject jobj = cr.saveRouteDetails(routeObj,systemId, userId, sessionId, serverName, clientId,tripCustId,legIds,zone);
						resp.getWriter().print(jobj);
					} else {
						JSONObject jobj  = new JSONObject();
						jobj.put("message", message.replace("<p class='errormessage'>", "").replace("</p>", ""));
						jobj.put("routeKey", 0);
						resp.getWriter().print(jobj);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("checkRouteExists")) {
				String routeName = req.getParameter("routeName");
				String tripCustId = req.getParameter("tripCustId");
				try {
					obj = new JSONObject();
					boolean check = gf.checkRouteExists(routeName, tripCustId,systemId,clientId);
					resp.getWriter().print(check);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equalsIgnoreCase("getSourceAndDestination"))
			{
				obj = new JSONObject();
				jArr = new JSONArray();
				int tripCustId=0;
				if(req.getParameter("tripCustId")!=null && !req.getParameter("tripCustId").equals("")){
					tripCustId=Integer.parseInt(req.getParameter("tripCustId"));
				}
				String type = req.getParameter("type");
  				try {
					if (tripCustId>0) {
						jArr = cr.getSourceDestination(clientId, systemId, zone,tripCustId,type);
					}
					if(jArr.length()>0){
						obj.put("sourceRoot",jArr);
					}else{
						obj.put("sourceRoot","");
					}
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}		
			else if (param.equalsIgnoreCase("saveTripData")) {
		        try {
		        	logWriter.log(" Start of the TripCreatAction.saveTripData method "+sessionId, LogWriter.INFO);
		            String custId = req.getParameter("CustId");
		            String routeId=req.getParameter("routeId");
		            String routeName=req.getParameter("routeName");
	                String vehicleNo=req.getParameter("vehicleNo");
	             	String plannedDate=req.getParameter("plannedDate");
	             	String addcustomerName=req.getParameter("addcustomerName");
	             	String customerName=req.getParameter("customerName");
	             	String custReference=req.getParameter("custReference");
	             	String filePath=req.getParameter("filePath");
	             	String viewFlag=req.getParameter("viewFlag");
	             	String startDate=req.getParameter("startDate");
	             	String endDate=req.getParameter("endDate");
	             	String minHumidity=req.getParameter("minHumidity");
	             	String maxHumidity=req.getParameter("maxHumidity");
	             	String tempeartureArray=req.getParameter("tempeartureArray");
	             	String selSensorsToAlertTrigger=req.getParameter("selSensorsToAlertTrigger");
	             	StringBuffer alertId=new StringBuffer(req.getParameter("alertId"));
	                alertId.append("58,106,45,3,7,182,174,186,187,188,189,190,196,93");
	                String alert= new String(alertId);
	                String avgSpeed = req.getParameter("avgSpeed");
		            String message1="";
		            String successMessage="";
		            String tripId="";
		            String [] message;
		            String peLoadTemp = req.getParameter("peLoadTemp");
		            String recordsCount = req.getParameter("recordsCount");
		            String drivers = req.getParameter("drivers");
		            String date = req.getParameter("date");
		            String legId = req.getParameter("legId");
		            String productLine = req.getParameter("productLine");
		            String category = req.getParameter("category");
		            String tripCustId = req.getParameter("tripCustId");
		            String sealNo = req.getParameter("sealNo");
		            int routeTemplateId = 0;
		            int noOfBags = 0;
		            if(!req.getParameter("noOfBags").equals("")){
		            	noOfBags=Integer.parseInt(req.getParameter("noOfBags"));
		            }
		            String tripType = req.getParameter("tripType");
		            int noOfFluidBags = 0;
		            if(!req.getParameter("noOfFluidBags").equals("") ){
		            	noOfFluidBags=Integer.parseInt(req.getParameter("noOfFluidBags"));
		            }
		            float openingKms=0;
		            if(!req.getParameter("openingKms").equals("")){
		            	openingKms=Float.parseFloat(req.getParameter("openingKms"));
		            }
		            String tripRemarks = req.getParameter("tripRemarks");
		            int materialId = 0;
		            
		            // For NTC requirement
		            
		            String materialClient = (req.getParameter("materialClient")!=null)? req.getParameter("materialClient"):"";
		            if("Y".equals(materialClient)){
		            	routeTemplateId = (req.getParameter("routeTemplateId") != null)?Integer.parseInt(req.getParameter("routeTemplateId")):0;
		            	productLine = "Dry";
		            	materialId = (req.getParameter("materialId") != null)?Integer.parseInt(req.getParameter("materialId")):0;
		            }
		            if (custId != null && !custId.equals("")) {
				              message1 = ctf.addTripDetails(systemId,Integer.parseInt(custId),userId,Integer.parseInt(routeId),vehicleNo,plannedDate,alert,routeName,offset,
				            		  addcustomerName,custReference,avgSpeed,tempeartureArray,selSensorsToAlertTrigger,minHumidity,maxHumidity,peLoadTemp,recordsCount,drivers,date,legId,
				            		  productLine,tripCustId,sessionId,serverName,sealNo,noOfBags,tripType,noOfFluidBags,openingKms,tripRemarks,routeTemplateId,materialId,logWriter,category,customerName);
		            }
		            if(!message1.equals("") && !message1.equals(null)){
		            	if(message1.contains(",")){	
			            	message=message1.split(",");
			            	tripId=message[1];
			            	successMessage = message[0]+"for "+tripId +" trip ID";
		            	}else{
		            		successMessage=message1;
		            	}
		            }
		            session.setAttribute("tripId", tripId);
		            session.setAttribute("filePath", filePath);
		            session.setAttribute("startDate", startDate);
		            session.setAttribute("endDate", endDate);
		            if (viewFlag != null && !viewFlag.equals("")) {
		            	session.setAttribute("viewFlag", viewFlag);
		            }
		            String tripName = "";
		            if(!tripId.equals("")){
		            	tripName = gf.getTripName(Integer.parseInt(tripId));
		            }
		            logWriter.log(" End of TripCreatAction.saveTripData method "+sessionId+"::message:"+message1, LogWriter.INFO);
		            if(message1.contains("Saved Successfully")){
		            	resp.getWriter().print(message1+","+tripName);
		            }else{
		            	resp.getWriter().print(message1);
		            }
		        } catch (Exception e) {
		        	logWriter.log(" Error in TripCreatAction.saveTripData method "+sessionId+ e.getMessage(), LogWriter.ERROR);
		            e.printStackTrace();
		        }
		    }
			 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
