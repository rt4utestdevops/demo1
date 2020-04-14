package t4u.Utilization;

import java.util.ArrayList;

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
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.SLAReport;
import t4u.functions.SlaReportLegExport;
import t4u.functions.UtilizationReportsFuntions;


public class UtilizationReportsAction extends Action{
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
			 String param = "";
			String zone="";
			int systemId=0;
			int userId=0;
			int offset=0;
			int clientId=0;
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
			UtilizationReportsFuntions utlization = new UtilizationReportsFuntions();
			systemId=loginInfo.getSystemId();
			//String lang = loginInfo.getLanguage();
			zone=loginInfo.getZone();
			userId=loginInfo.getUserId();
			offset=loginInfo.getOffsetMinutes();
			String lang = loginInfo.getLanguage();
			clientId=loginInfo.getCustomerId();
			zone = loginInfo.getZone();
			CommonFunctions cf = new CommonFunctions();
			JSONArray jsonArray = null;
			JSONObject jsonObject = new JSONObject();
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}  
	    
			if(param.equals("getAssetGroup")){
				try{
			      	String customerId = request.getParameter("CustId");
					jsonObject = new JSONObject();
					if(customerId != null){
							jsonArray = utlization.getAssetGroup(systemId, Integer.parseInt(customerId),userId);
							jsonObject.put("assetGroupRoot", jsonArray);
					}
					else{
						    jsonObject.put("assetGroupRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
			 }
			
			if(param.equals("getAssetGroupExceptAll")){
				try{
			      	String customerId = request.getParameter("CustId");
					jsonObject = new JSONObject();
					if(customerId != null){
							jsonArray = utlization.getAssetGroupExceptAll(systemId, Integer.parseInt(customerId),userId);
							jsonObject.put("assetGroupRoot", jsonArray);
					}
					else{
						    jsonObject.put("assetGroupRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
			 }
			
			
			else if(param.equals("getDataForWorkingDaysAfterWorkingHrs")){
				try{
			      	String customerId = request.getParameter("custID");
			      	String assetGruopId = request.getParameter("groupId");
			      	String startDate = request.getParameter("startdate");
			      	String endDate = request.getParameter("enddate");
			      	String jspName = request.getParameter("jspName");
			      	String custName = request.getParameter("CustName");
					jsonObject = new JSONObject();
					  if (customerId != null && !customerId.equals("")) {
						  ArrayList < Object >  list1 = utlization.getDataForWorkingDaysAfterWorkingHrsReport(systemId, Integer.parseInt(customerId),Integer.parseInt(assetGruopId),lang,startDate,endDate,offset,userId);
							jsonArray = (JSONArray) list1.get(0);
							if (jsonArray.length() > 0) {
							jsonObject.put("VehicleUtilizationRoot", jsonArray);
					}else {
	                    jsonObject.put("VehicleUtilizationRoot", "");
	                }
							
					 ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("customerId", custName);
		                request.getSession().setAttribute("startDate",cf.getFormattedDate(startDate.replaceAll("T", " ")));
			    		request.getSession().setAttribute("endDate",cf.getFormattedDate(endDate.replaceAll("T", " ")));
		            } else {
		                jsonObject.put("VehicleUtilizationRoot", "");
		            }
		            response.getWriter().print(jsonObject.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
				
			 } else	if (param.equalsIgnoreCase("getUtilizationWorkingHolidaysAndWeekendReport")) {
	        try {
	            String customerId = request.getParameter("custID");
	            String assetGruopId = request.getParameter("assetGroup");
	            String startDate= request.getParameter("startdate");
	            String endDate= request.getParameter("enddate");
	            String custName=request.getParameter("custName");
	            String jspName=request.getParameter("jspName");
	            jsonArray = new JSONArray();
	            
	            if (customerId != null && !customerId.equals("")) {
					ArrayList < Object > list1 = utlization.getUtilizationWorkingHolidaysAndWeekendReport(systemId, Integer.parseInt(customerId),Integer.parseInt(assetGruopId),userId, lang,startDate,endDate,offset);
	            	jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("utilizationDuringHolidayAndWeekendsRoot", jsonArray);
	                } else {
	                    jsonObject.put("utilizationDuringHolidayAndWeekendsRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("customerId", custName);
	                request.getSession().setAttribute("startDate",cf.getFormattedDate(startDate.replaceAll("T", " ")));
		    		request.getSession().setAttribute("endDate",cf.getFormattedDate(endDate.replaceAll("T", " ")));
		    		response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("utilizationDuringHolidayAndWeekendsRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        
    	}else if(param.equals("getDataForWorkingDaysWorkingHrs")){
			try{
		      	String customerId = request.getParameter("custId");
		      	String assetGruopId = request.getParameter("groupId");
		      	String jspName = request.getParameter("jspName");
		    	String custName = request.getParameter("custName");
		    	String startDate = request.getParameter("startDate");
		    	String endDate = request.getParameter("endDate");
		        jsonObject = new JSONObject();
		        
	            if (customerId != null && !customerId.equals("")) {
                   	ArrayList < Object > list1 = utlization.getDataForWorkingDaysWorkingHrsReport(systemId, Integer.parseInt(customerId),Integer.parseInt(assetGruopId),startDate,endDate,lang,offset,userId);
	            	jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("utilizationdata", jsonArray);
	                } else {
	                    jsonObject.put("utilizationdata", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("customerId", custName);
	                request.getSession().setAttribute("startDate",cf.getFormattedDate(startDate.replaceAll("T", " ")));
		    		request.getSession().setAttribute("endDate",cf.getFormattedDate(endDate.replaceAll("T", " ")));
	            } else {
	                jsonObject.put("utilizationdata", "");
	            }
	           
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	
    	}	
//--------------------------------------------------------------------
		if (param.equalsIgnoreCase("getUtilizationSummaryReport")) {
	        try {
	            String customerId = request.getParameter("custID");
	            String assetGroupId=request.getParameter("assetGroup");
	            String startDate= request.getParameter("startdate");
	            String endDate= request.getParameter("enddate");
	            String custName=request.getParameter("custName");
	            String jspName=request.getParameter("jspName");
	            
	            jsonArray = new JSONArray();
	            
	            if (customerId != null && !customerId.equals("")) {
					ArrayList < Object > list1 = utlization.getUtilizationSummaryReport(systemId, Integer.parseInt(customerId),Integer.parseInt(assetGroupId), userId, lang,startDate,endDate,offset);
	            	jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("utilizationSummaryReportRoot", jsonArray);
	                } else {
	                    jsonObject.put("utilizationSummaryReportRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("customerId", custName);
	                request.getSession().setAttribute("startDate",cf.getFormattedDate(startDate.replaceAll("T", " ")));
		    		request.getSession().setAttribute("endDate",cf.getFormattedDate(endDate.replaceAll("T", " ")));
		    		response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("utilizationSummaryReportRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	
    	}	

		
		if (param.equalsIgnoreCase("getUtilizationWorkingReport")) {
	        try {
	            String customerId = request.getParameter("custID");
	            String startDate= request.getParameter("startdate");
	            String endDate= request.getParameter("enddate");
	            String custName=request.getParameter("custName");
	            String jspName=request.getParameter("jspName");
	            String groupId=request.getParameter("assetGroup");
	            jsonArray = new JSONArray();
	            
	            if (customerId != null && !customerId.equals("")) {
                   	ArrayList < Object > list1 = utlization.getUtilizationWorkingReport(systemId, Integer.parseInt(customerId), userId, lang,startDate,endDate,offset,zone,Integer.parseInt(groupId));
	            	jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("utilizationWorkingDaysRoot", jsonArray);
	                } else {
	                    jsonObject.put("utilizationWorkingDaysRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("customerId", custName);
	                request.getSession().setAttribute("startDate",cf.getFormattedDate(startDate.replaceAll("T", " ")));
		    		request.getSession().setAttribute("endDate",cf.getFormattedDate(endDate.replaceAll("T", " ")));
		    		response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("utilizationWorkingDaysRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	
    	}
		
		/*
		 * 
		 * Sla report	
		 */
		else if(param.equals("getSlaReport"))
		{
			String startDate = request.getParameter("startDate")+" 00:00:00";
			String endDate = request.getParameter("endDate")+" 23:59:59";
			SLAReport generaterReport= new SLAReport();
			
			try {
				String  message =generaterReport.getTripDetails(startDate, endDate, systemId, clientId, offset,userId);
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getCEReport"))
		{
			String cust=request.getParameter("customer");
			String startDate = request.getParameter("startDate")+" 00:00:00";
			String endDate = request.getParameter("endDate")+" 23:59:59";
			SLAReport generaterReport= new SLAReport();
			try {
				String  message =generaterReport.getCETripDetails(startDate, endDate, systemId, Integer.parseInt(cust), offset,userId);
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if(param.equals("getSlaLegWiseReport"))
		{
			String startDate = request.getParameter("startDate")+" 00:00:00";
			String endDate = request.getParameter("endDate")+" 23:59:59";
			SlaReportLegExport legExport = new SlaReportLegExport();
			try {
				String  message =legExport.legDetails(startDate, endDate, systemId, clientId, offset,userId);
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
return null;
	}
}