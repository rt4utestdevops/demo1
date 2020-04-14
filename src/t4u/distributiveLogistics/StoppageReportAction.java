package t4u.distributiveLogistics;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;
import java.util.Vector;

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
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.DistributionLogisticsFunctions;
import t4u.functions.LogWriter;


public class StoppageReportAction extends Action{
	DistributionLogisticsFunctions sqlfunc=new DistributionLogisticsFunctions();
	CommonFunctions cf= new CommonFunctions();
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		ActionForward forward = null;
			HttpSession session = request.getSession();
			AdminFunctions adfunc= new AdminFunctions();
			LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
			int systemId=loginInfo.getSystemId();
			int customerID=loginInfo.getCustomerId();
			int createdUser=loginInfo.getUserId();
			int userId = loginInfo.getUserId();
			int offset = loginInfo.getOffsetMinutes();
			String zone=loginInfo.getZone();
			JSONArray jsonArray = null;
			JSONObject jsonObject = null;
			String param = "";
			SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			SimpleDateFormat sd1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			SimpleDateFormat sd2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if(request.getParameter("param")!=null)
			{
				param=request.getParameter("param").toString();
			}
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

		if(param.equals("getstopReport"))
		{
			String startDateFormated = "";
			String endDateFormated = "";
			String startDateTime = "";
			String endDateTime = "";
		
			try
			{
				JSONArray list = new JSONArray(); 
				JSONObject rslt = new JSONObject();
				
				if(request.getParameter("startdate")!=null && request.getParameter("enddate")!=null && request.getParameter("regno")!=null){
					
					//String startdate ="01/06/2016 05:00:000";//request.getParameter("startdate");"dd/MM/yyyy HH:mm:ss"
					//String enddate="03/06/2016 20:00:000";//request.getParameter("enddate");
					//String clientName="4858";//request.getParameter("clientname");
					
					String startdate =request.getParameter("startdate");
					String enddate=request.getParameter("enddate");
					String clientName=request.getParameter("custID");
					String regno=request.getParameter("regno");
					
					//System.out.println("startdate from front end... : "+startdate);
					//System.out.println("enddate from front end... : "+enddate);
					
					startDateFormated = ConvertLOCALtoGMT(sd1.format(sd2.parse(startdate)),offset);
					endDateFormated = ConvertLOCALtoGMT(sd1.format(sd2.parse(enddate)),offset);
					
					//System.out.println("startdate from back end... : "+startDateFormated);
					//System.out.println("enddate from back end... : "+endDateFormated);
					
					Date startDateFormated1 = sdfFormatDate.parse(startDateFormated);
					
					Date endDateFormated1 = sdfFormatDate.parse(endDateFormated);
					
					//System.out.println("startDateFormated1 from back end... : "+startDateFormated1);
					//System.out.println("endDateFormated1 from back end... : "+endDateFormated1);
				
					session.setAttribute("strtdateForStopRepo",startdate);
					session.setAttribute("enddateForStopRepo",enddate);
					session.setAttribute("RegNo",regno);
					
					//System.out.println("##############startdate  "+startDateFormated1+"  enddate "+endDateFormated1);
					//System.out.println("clientName: "+clientName);
					//System.out.println("SystemId: "+ systemId);
					//System.out.println("Offset: "+offset);
					String SystemId= systemId+"";
					Vector v =sqlfunc.getStopReport(startDateFormated1,endDateFormated1,regno,clientName,SystemId,offset,session);
					list=(JSONArray) v.get(0);
					
					 if(list.length()>0)
						{
							ReportHelper reportHelper = (ReportHelper)  v.get(1);
			                request.getSession().setAttribute("StoppageRepotEcom", reportHelper);
			                request.getSession().setAttribute("VehicleNo", regno);
						}
				
					//session.setAttribute("StoppageRepotEcom", reportHelper);	
					
					rslt.put("StopReport", list);
					//session.setAttribute("StopReportNew_Client_Name", "", systemId));
				} 	
				else{
					rslt.put("StopReport", "");
				}
			//	System.out.println("list...."+list);
		        response.getWriter().print(rslt.toString());
				 
			   
			}catch(Exception e)
			{
				e.printStackTrace();
				System.out.println("Error.."+e);
			}
		}
		if(param.equalsIgnoreCase("getAPMTTripDetails"))
		{
			try
			{
				
				String customerid=request.getParameter("CustId");
				String customerName= request.getParameter("custName");
				
				String startDate = request.getParameter("startDate").replace('T', ' ');
	            String endDate = request.getParameter("endDate").replace('T', ' ');
				String jspName = request.getParameter("jspName");


				jsonArray = new JSONArray();
			   jsonObject = new JSONObject();
				ArrayList < Object > list1 = null;
				if(!customerName.equals(""))
				{
				   list1 = sqlfunc.getAPMTTripDetails(systemId,customerid,startDate,endDate,offset);
				jsonArray = (JSONArray) list1.get(0);
				//System.out.println(jsonArray);
				jsonObject.put("ServiceTypeRoot",jsonArray);
				  if(jsonArray.length()>0)
					{
						ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("custName",customerName);
		                request.getSession().setAttribute("startDate", startDate);
		                request.getSession().setAttribute("endDate", endDate);
					}
					else
					{
						jsonObject.put("ServiceTypeRoot", "");
					}
					}
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				System.out.println("Exception in WebAPMTTripDetails:-getAPMTTripDetails "+e.toString());
			}
		}
		if (param != null && param.equals("getRegNosNew")) {
			try {
				String clientIdSelected = request.getParameter("globalClientId");
				String groupid = request.getParameter("globalGroupId");
				
				jsonArray = new JSONArray(); 
				jsonObject = new JSONObject();
				
				if (clientIdSelected != null) {
					if (groupid == null || groupid.equals("0") || groupid.equals("")) {
						groupid = null;
					}
					jsonArray = sqlfunc.getVehicleNo(systemId,Integer.parseInt(clientIdSelected) , userId,groupid);
					jsonObject.put("RegNosNew", jsonArray);
				} else {
					jsonObject.put("RegNosNew", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param != null && param.equals("getVehicleRegNosNew")) {
			try {
				String clientIdSelected = request.getParameter("globalClientId");
				String dateId = request.getParameter("date");				
				
				jsonArray = new JSONArray(); 
				jsonObject = new JSONObject();
				
				if (clientIdSelected != null) {
					/*if (groupid == null || groupid.equals("0") || groupid.equals("")) {
						groupid = null;
					}*/
					jsonArray = sqlfunc.getVehicleNumbersByCustomerId(systemId,Integer.parseInt(clientIdSelected) , userId, dateId);
					jsonObject.put("RegNosNew", jsonArray);
				} else {
					jsonObject.put("RegNosNew", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(param.equalsIgnoreCase("AddorModify"))
		{

			try
			{
				String buttonValue = request.getParameter("buttonValue");
				String custId=request.getParameter("CustId");			
				String groupId = request.getParameter("groupId");
				String groupName = request.getParameter("groupName");
				String VehicleNo = request.getParameter("VehicleNo");
				String dateId = request.getParameter("dateId");
				String currentDateId = request.getParameter("currentDateId");
				String id = request.getParameter("id");
				
				String message="";
				if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
				{
					message=sqlfunc.addVehicleReportingDetails(groupId,groupName,VehicleNo,currentDateId,systemId,Integer.parseInt(custId),dateId);
					
				}else if(buttonValue.equals("Modify") && (custId != null && !custId.equals("")) && (id !=null && !id.equals("")))
				{
					message=sqlfunc.modifyVehicleReportingDetails(groupId,VehicleNo,currentDateId,systemId,Integer.parseInt(custId),userId,dateId,id);
				}
				
				response.getWriter().print(message);
			}catch(Exception e)
			{
				e.printStackTrace();
			}
		
		}
		
		if(param.equalsIgnoreCase("getVehicleReportingDetails"))
		{
	    	try {
	            String customerId = request.getParameter("CustId");
	            String customerName = request.getParameter("CustName");
				String groupId = request.getParameter("groupId");
				String groupName = request.getParameter("groupName");
				String dateId = request.getParameter("dateId");
				String jspName = request.getParameter("jspName");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (customerId != null && !customerId.equals("")) {
	                ArrayList < Object > list1 = sqlfunc.getVehicleReportingDetails(systemId, Integer.parseInt(customerId), groupId, dateId);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("VelicleReportingRoot", jsonArray);
	                    ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("custName",customerName);
		                request.getSession().setAttribute("groupName",groupName);
		                request.getSession().setAttribute("dateId",dateId);
	                } else {
	                    jsonObject.put("VelicleReportingRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("VelicleReportingRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        }catch (Exception e) {
				e.printStackTrace();
			}	
	    }
		if (param.equals("getLocation")) {
			try {
				String customerId = request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (customerId != null ) {
				jsonArray = sqlfunc.getLocation( systemId, Integer.parseInt(customerId),userId);
				jsonObject.put("locationroot", jsonArray);
				} else {
					jsonObject.put("locationroot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		if (param.equals("getVehicleNo")) {
			try {
				String customerId = request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (customerId != null ) {
				jsonArray = sqlfunc.getVehicles( systemId, Integer.parseInt(customerId),userId);
				jsonObject.put("vehicleroot", jsonArray);
				} else {
					jsonObject.put("vehicleroot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		if(param.equalsIgnoreCase("AddTripGeneration"))
		{

			try
			{
				String buttonValue = request.getParameter("buttonValue");
				String custId=request.getParameter("CustId");			
				String amazonTripId = request.getParameter("amazonTripId");
				String sourceLocation = request.getParameter("sourceLocation");
				String VehicleNo = request.getParameter("VehicleNo");
				String destinationLocation = request.getParameter("destinationLocation");
				String destinationTime = request.getParameter("destinationTime");
				String destinationDistance = request.getParameter("destinationDistance");
				String[] touchPointCombo = request.getParameterValues("touchPointCombo");
				String[] touchPointTime = request.getParameterValues("touchPointTime");
				String[] touchPointDistance = request.getParameterValues("touchPointDistance");
				String driverName = request.getParameter("driverName");
				String mobileNo = request.getParameter("mobileNo");
				String dateId = request.getParameter("dateId").replace("T", " ");
				String routeName = request.getParameter("routeName");
				String totalTime = request.getParameter("totalTime");
				String totalDistance = request.getParameter("totalDistance");
				String message="";
				if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
				{
					if(destinationLocation != null && destinationTime != null && destinationDistance != null && !destinationLocation.equals("") && !destinationTime.equals("") && !destinationDistance.equals("")){
					message=sqlfunc.addTripGenerationDetails(amazonTripId,VehicleNo,sourceLocation,destinationLocation,destinationTime,destinationDistance,touchPointCombo,touchPointTime,touchPointDistance,systemId,Integer.parseInt(custId),driverName,mobileNo,userId,dateId,routeName,totalTime,totalDistance);
				}
					else{
						message="Please Select Destination";
					}
				}
				response.getWriter().print(message);
			}catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		if(param.equalsIgnoreCase("getTripGenerationDetails"))
		{
	    	try {
	            String customerId = request.getParameter("CustId");
	            String jspName = request.getParameter("jspName");
	            String customerName = request.getParameter("CustName");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (customerId != null && !customerId.equals("")) {
	                ArrayList < Object > list1 = sqlfunc.getTripGenerationDetails(systemId, Integer.parseInt(customerId));
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("TripGenerationRoot", jsonArray);
	                    ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("custName",customerName);
	                } else {
	                    jsonObject.put("TripGenerationRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("TripGenerationRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        }catch (Exception e) {
				e.printStackTrace();
			}	
	    }
		
		if (param.equals("distributionLogisticsDashboardNewElements")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = sqlfunc.distributionLogisticsDashboardNewCountsDetails(systemId,customerID,userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("dashboardElementsRoot", jsonArray);
				} else {
					jsonObject.put("dashboardElementsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equals("distributionLogisticsDashboardNewElementsCount")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = sqlfunc.distributionLogisticsDashboardNewCounts(systemId,customerID,userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("dashboardElementsCountRoot", jsonArray);
				} else {
					jsonObject.put("dashboardElementsCountRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equals("getDahBoardDetails")) {
			try {
				jsonObject = new JSONObject();
				String type=request.getParameter("type");
				String jspName=request.getParameter("jspname");
				if(type==null){
					type="";
				}
				ArrayList<Object> list = new ArrayList<Object>();
				list = sqlfunc.getDashBoardDetails(systemId,customerID,type,userId);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("dasBoardRoot", jsonArray);
					 ReportHelper reportHelper = (ReportHelper) list.get(1);
		             request.getSession().setAttribute(jspName, reportHelper);
		             //request.getSession().setAttribute("custName",customerName);
				} else {
					jsonObject.put("dasBoardRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getColumnHeaders")){

			try {
				jsonObject = new JSONObject();
				jsonArray = sqlfunc.getColumnHeaders(systemId,customerID,userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("firstGridRoot", jsonArray);
				} else {
					jsonObject.put("firstGridRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
        else if (param.equalsIgnoreCase("associateHeaders")) {
            String message = "";
            String s = request.getParameter("gridData");
            try {
                if (s != null) {
                    String st = "[" + s + "]";
                    JSONArray js = null;
                    try {
                        js = new JSONArray(st.toString());
                        if (js.length() > 0) {
                            message = sqlfunc.associateHeader(customerID, systemId,js,userId);
                        } else {
                            message = "";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    message = "No Data To Save";
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        else if(param.equalsIgnoreCase("getVehicleAllocations"))
		{
	    	try {
	            String customerId = request.getParameter("CustId");
	            String customerName = request.getParameter("CustName");
				String hubId = request.getParameter("hubId");
				String hubName = request.getParameter("hubName");
				String startDate = request.getParameter("dateId");
				String endDate = request.getParameter("dateId");
				startDate = startDate + " 00:00:00";
				endDate = endDate + " 23:59:59";
				String jspName = request.getParameter("jspName");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            ArrayList < Object > list1 = null;
	            if (customerId != null && !customerId.equals("")) {
	            	list1 = sqlfunc.getVehicleAllocations(systemId, Integer.parseInt(customerId), Integer.parseInt(hubId), startDate, endDate ,offset,zone,userId);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                   jsonObject.put("VelicleReportingRoot", jsonArray);
	                   ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("custName",customerName);
		               // request.getSession().setAttribute("groupName",groupName);
		                //request.getSession().setAttribute("dateId",startDate);
		                //request.getSession().setAttribute("dateId",endDate);
	                } else {
	                    jsonObject.put("VelicleReportingRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("VelicleReportingRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        }catch (Exception e) {
				e.printStackTrace();
			}	
	    }
        else if(param.equalsIgnoreCase("saveVehicleNumberAndTime"))
		{
			try
			{
				LogWriter logWriter = null;
				Properties properties = ApplicationListener.prop;
				String logFile = properties.getProperty("LogFileForVehicleReporting");
				String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
				String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
				logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;
				PrintWriter pw;
				if (logFile != null) {
					try {
						pw = new PrintWriter(new FileWriter(logFile, true), true);
						logWriter = new LogWriter(
								"saveVehicleNumberAndTime" + "-- " + session.getId() + "--" + userId,
								LogWriter.INFO, pw);
						logWriter.setPrintWriter(pw);
					} catch (IOException e) {
						logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
								LogWriter.ERROR);
					}
				}
				logWriter.log(" Begining of the method ", LogWriter.INFO);
				String json = request.getParameter("json");
				String hubId = request.getParameter("hubId");
				String dateId = request.getParameter("dateId").replace("T", " ");
				String customerId = request.getParameter("CustId");
	            String jspName = request.getParameter("jspName");
	            String customerName = request.getParameter("CustName");
				String message="";
				logWriter.log(" customerId from JSP "+customerId+" customerId from session "+customerID,LogWriter.INFO);
				boolean valid = true;
				ArrayList<String> categoryList = new ArrayList<String>();
				if(json != null){
					String st = "["+json+"]";
					JSONArray js = null;
					try{
						js = new JSONArray(st.toString());
					}catch(JSONException e){
						e.printStackTrace();
					}
					for(int i = 0; i<js.length(); i++){
						jsonObject = js.getJSONObject(i);
						if(!jsonObject.getString("selectVehicleIndex").equals("")){
							categoryList.add(jsonObject.getString("selectVehicleIndex"));
						}
					}	
					if(categoryList.size()>0){
						for(int j = 0; j<categoryList.size();j++){
							for(int k=j+1; k<categoryList.size();k++){
								if(categoryList.get(j).equals(categoryList.get(k))){
									message = categoryList.get(j)+" is repeated..!!!";
									valid = false;
								}
							}
						}
					}
					if(valid){
						if(customerId != null && !customerId.equals("") && !customerId.equals("0")){
							message = sqlfunc.saveVehicleNumberAndTime(systemId,Integer.parseInt(customerId),js,hubId ,dateId,logWriter,session.getId());
							logWriter.log(" End of the method "+message, LogWriter.INFO);
							
						}else{
							message = "Error!!";
							logWriter.log(" saveVehicleNumberAndTime Error!! customerId is null", LogWriter.ERROR);
						}
					}
					response.getWriter().print(message.toString());
				}
				
			}catch(Exception e)
			{
				e.printStackTrace();
			}
		
		}
	
	return null;	
		
	}
	
	public String ConvertLOCALtoGMT(String dateFormatOldInLOCAL,int offset )
	{
		String newDateFormattedInGMT = "";
		try
		{
			if(dateFormatOldInLOCAL.contains("T")){
				dateFormatOldInLOCAL = dateFormatOldInLOCAL.substring(0,dateFormatOldInLOCAL.indexOf("T"))+" "+ dateFormatOldInLOCAL.substring(dateFormatOldInLOCAL.indexOf("T")+1, dateFormatOldInLOCAL.length());
				dateFormatOldInLOCAL = getFormattedDateStartingFromMonth(dateFormatOldInLOCAL);
				newDateFormattedInGMT = cf.getLocalDateTime(dateFormatOldInLOCAL,offset);
	    	}
			else
			{
				dateFormatOldInLOCAL = getFormattedDateStartingFromMonth(dateFormatOldInLOCAL);
				newDateFormattedInGMT = cf.getLocalDateTime(dateFormatOldInLOCAL,offset);
			}
		}
		catch (Exception e) 
		{
		 	e.printStackTrace();
		}
		return newDateFormattedInGMT;
	}
	public String getFormattedDateStartingFromMonth(String inputDate)
	{
		 String formattedDate="";
		 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		 SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		 SimpleDateFormat sdfFormatDate1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		 try
		 {
			 if(inputDate!=null && !inputDate.equals(""))
			 {
			 java.util.Date d=sdfFormatDate1.parse(inputDate);
			 formattedDate=sdfFormatDate.format(d);
			 }
			 
		 }
		 catch(Exception e)
		 {
			 System.out.println("Error in getFormattedDateStartingFromMonth() method"+e);
			 e.printStackTrace();
		 }
		 return formattedDate;
	}
}

