package t4u.staffTransportationSolution;


import java.text.SimpleDateFormat;
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

import t4u.functions.StaffTransportationSolutionFunctions;


public class VehicleTripSummaryAction  extends Action
{
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   	 
//		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    	HttpSession session = request.getSession();
	        String param = "";
	        int systemId = 0;
//	        int userId = 0;
	        int offset =0;
	        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	        systemId = loginInfo.getSystemId();
//	        userId = loginInfo.getUserId();
	        offset = loginInfo.getOffsetMinutes();
	        StaffTransportationSolutionFunctions stsfunc = new StaffTransportationSolutionFunctions();
	        JSONArray jsonArray = null;
	        JSONObject jsonObject = new JSONObject();
	        if (request.getParameter("param") != null) {
	            param = request.getParameter("param").toString();
	        }
	        if(param.equalsIgnoreCase("getShiftNames")){
	        try {
                String customerId = request.getParameter("CustId");
                String branchId = request.getParameter("BranchId");
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("")) {
                	jsonArray = stsfunc.getShiftNamesByBranch(systemId, Integer.parseInt(customerId), Integer.parseInt(branchId));
                    if (jsonArray.length() > 0) {
                        jsonObject.put("ShiftRoot", jsonArray);
                    } else {
                        jsonObject.put("ShiftRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("ShiftRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            }catch (Exception e) {
    			e.printStackTrace();
    		}
        } 	
	        else if(param.equals("validate")){

	    		try
	    		{
	    			String message = "";
	                String shiftId = request.getParameter("ShiftId");
	                String endDate  =  request.getParameter("endDate");
	                String branchId = request.getParameter("BranchId");
	                String custId = request.getParameter("CustId");
	    			if( shiftId != null && !shiftId.equals(""))
	    			{
	    				message=stsfunc.CheckShiftEndTime(Integer.parseInt(shiftId),endDate,Integer.parseInt(branchId),systemId,Integer.parseInt(custId));	    				
	    			}
	    			
	    			response.getWriter().print(message);
	    		}catch(Exception e)
	    		{
	    			e.printStackTrace();
	    		}
	        	
	        }
	        
	        else if(param.equals("getVehicleGroup")){
	    		try{
	    			
	    			String clientId = request.getParameter("clientId");
	    			   jsonObject = new JSONObject();
	    			   jsonArray = new JSONArray();
	    			if(clientId != null && !clientId.equals("")){			
	    				jsonArray = stsfunc.getVehicleGroupFromShiftMaster(systemId, Integer.parseInt(clientId));				
	    				jsonObject.put("BranchStoreRootUser", jsonArray);
	    			}else{
	    				jsonObject.put("BranchStoreRootUser", "");
	    			}			
	    			response.getWriter().print(jsonObject.toString());
	    		}
	    		catch(Exception e){
	    			e.printStackTrace();
	    		}
	    	}
	        
	        else if(param.equals("getShiftWiseVehicleDetails")){
	    		try{
	    			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	                SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    		   String clientId = request.getParameter("CustId");
	    		   String BranchId = "0";
	    		   String ShiftId = "0";
	    		   String startDate = request.getParameter("startDate");
	    		   String endDate = request.getParameter("endDate");
	    		   String startTime = request.getParameter("startTime");
	    		   String endTime = request.getParameter("endTime");
	    		   String vehicleNo = request.getParameter("vehicleNo");
	    		   String jspName = request.getParameter("jspName");
	    		   String custName = request.getParameter("custName");
	    		   String startDateTime="";
	    		   String endDateTime="";
	    		   if(startDate!="" && !startDate.equals("") && startTime!=null && !startTime.equals("")){
	    			   startDateTime=startDate+" "+startTime;
	    		   }
	    		   if(endDate!="" && !endDate.equals("") && endTime!=null && !endTime.equals("")){
	    			   endDateTime=endDate+" "+endTime;
	    		   }
	    		   if(request.getParameter("ShiftId")!=null && !request.getParameter("ShiftId").equals("")){
	    			   ShiftId=request.getParameter("ShiftId");
	    		   }
	    		   if(request.getParameter("BranchId")!=null && !request.getParameter("BranchId").equals("")){
	    			   BranchId=request.getParameter("BranchId");
	    		   }
    			   jsonObject = new JSONObject();
    			   jsonArray = new JSONArray();
    			   ArrayList list=null;
    			   if(clientId != null && !clientId.equals("")){
    				   list = stsfunc.getShiftWiseVehicleDetails(systemId, Integer.parseInt(clientId),startDateTime,endDateTime,Integer.parseInt(BranchId),Integer.parseInt(ShiftId),vehicleNo);		
    				   jsonArray = (JSONArray) list.get(0);
    				   if (jsonArray.length() > 0) {
		                    jsonObject.put("detailsStoreRoot", jsonArray);
		                } else {
		                    jsonObject.put("detailsStoreRoot", "");
		                }
    				   
    				   ReportHelper reportHelper = (ReportHelper) list.get(1);
           			   request.getSession().setAttribute(jspName, reportHelper);
                       request.getSession().setAttribute("custId", "");
                       request.getSession().setAttribute("jspName", jspName);
                       request.getSession().setAttribute("vehicleNo", vehicleNo);
	               	   request.getSession().setAttribute("startdate", df.format(sdf.parse(startDateTime)));
	           	       request.getSession().setAttribute("enddate", df.format(sdf.parse(endDateTime)));
		    		   response.getWriter().print(jsonObject.toString());
	    		}
	    		}
	    		catch(Exception e){
	    			e.printStackTrace();
	    		}
	    	}
	        
	        
	        else if(param.equalsIgnoreCase("View"))
    	{
	        	 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	                SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
    		try {
                String customerId = request.getParameter("CustId");
                String branchId = request.getParameter("BranchId");
                String shiftId = "0";
                if(request.getParameter("ShiftId") != null && !request.getParameter("ShiftId").equalsIgnoreCase("")){
                shiftId = request.getParameter("ShiftId");
                }
                String date = request.getParameter("Date");
                String eDate = request.getParameter("endDate");
                String jspName = request.getParameter("JspName");
                String custName = request.getParameter("CustName");
                String branchName =  request.getParameter("BranchName");
                String shiftName =  request.getParameter("ShiftName");
                String buttonValue = request.getParameter("buttonValue");
                String SatrtTime ="";
                String EndTime = "";
                if(buttonValue.equalsIgnoreCase("ShiftWise")){
                date = date.substring(0,date.indexOf("T"));
                eDate=eDate.substring(0,eDate.indexOf("T"));
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                df = new SimpleDateFormat("dd-MM-yyyy");
                SatrtTime = request.getParameter("SatrtTime");
                EndTime = request.getParameter("EndTime");
                jspName = "ShiftWise Trip Summary Report";
                }else{
                	 date = date.replace("T", " ");
                     eDate=eDate.replace("T", " ");
                     sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                     df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");	
                     jspName = "DateWise Trip Summary Report";
                }
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("")) {
                    ArrayList < Object > list = stsfunc.getViewDetails(systemId, Integer.parseInt(customerId),Integer.parseInt(branchId),Integer.parseInt(shiftId), date,eDate,offset,buttonValue);
                    jsonArray = (JSONArray) list.get(0);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("ViewRoot", jsonArray);
                    } else {
                        jsonObject.put("ViewRoot", "");
                    }
                    
                    ReportHelper reportHelper = (ReportHelper) list.get(1);
        			request.getSession().setAttribute(jspName, reportHelper);
                    request.getSession().setAttribute("custId", custName);
                    request.getSession().setAttribute("jspName", jspName);
                    request.getSession().setAttribute("branchName", branchName);
            		request.getSession().setAttribute("startDate", df.format(sdf.parse(date)));
        	     	request.getSession().setAttribute("endDate", df.format(sdf.parse(eDate)));
        	     	if(buttonValue.equalsIgnoreCase("ShiftWise")){
        	     	request.getSession().setAttribute("startTime", SatrtTime);
        	     	request.getSession().setAttribute("endTime", EndTime);
                    request.getSession().setAttribute("shiftName", shiftName);
        	     	}
        			response.getWriter().print(jsonObject.toString());
                  
                } else {
                    jsonObject.put("ViewRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            }catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
	        
	        else if(param.equals("getReportType")){
	    		try{
	    			JSONObject jsonobj = new JSONObject();
	    			JSONArray JsonArray1 = new JSONArray();
	    			jsonobj.put("ReportTypeId", "0");
	    			jsonobj.put("ReportTypeName", "Daywise");
	    			JsonArray1.put(jsonobj);
	    			jsonobj = new JSONObject();
	    			jsonobj.put("ReportTypeId", "1");
	    			jsonobj.put("ReportTypeName", "Shiftwise");
	    			JsonArray1.put(jsonobj);
	    			jsonObject.put("TypeRoot", JsonArray1);
	    			response.getWriter().print(jsonObject.toString());
	    		}
	    		catch(Exception e){
	    			e.printStackTrace();
	    		}
	    	}      
	        
	        
return null;
	}
}
