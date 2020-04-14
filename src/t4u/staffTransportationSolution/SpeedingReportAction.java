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


public class SpeedingReportAction  extends Action
{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   	 
	    	HttpSession session = request.getSession();
	        String param = "";
	        int systemId = 0;
	        int offset =0;
	        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	        systemId = loginInfo.getSystemId();
	        offset = loginInfo.getOffsetMinutes();
	        StaffTransportationSolutionFunctions stsfunc = new StaffTransportationSolutionFunctions();
	        JSONArray jsonArray = null;
	        JSONObject jsonObject = new JSONObject();
	        if (request.getParameter("param") != null) {
	            param = request.getParameter("param").toString();
	        }
	
	        if(param.equalsIgnoreCase("getVehicleNo")){
	        	try {
	                String customerId = request.getParameter("CustId");
	                String branchId = request.getParameter("BranchId");
	                jsonArray = new JSONArray();
	                if (customerId != null && !customerId.equals("")) {
	                	jsonArray = stsfunc.getVehicles(systemId, Integer.parseInt(customerId),Integer.parseInt(branchId));
	                   
	                    if (jsonArray.length() > 0) {
	                        jsonObject.put("VehicleNoRoot", jsonArray);
	                    } else {
	                        jsonObject.put("VehicleNoRoot", "");
	                    }
	                    response.getWriter().print(jsonObject.toString());
	                } else {
	                    jsonObject.put("VehicleNoRoot", "");
	                    response.getWriter().print(jsonObject.toString());
	                }
	            }catch (Exception e) {
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
	        
	        
	        else if(param.equalsIgnoreCase("View"))
    	{
	        	 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	                SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
    		try {
    			ArrayList list=null;
                String customerId = request.getParameter("CustId");
                String branchId = request.getParameter("BranchId");
                String vehicleId = request.getParameter("vehicleId");
                String date = request.getParameter("Date");
                String eDate = request.getParameter("endDate");
                String jspName = request.getParameter("JspName");
                String custName = request.getParameter("CustName");
                String branchName =  request.getParameter("BranchName");
                date = date.replace("T", " ");
                eDate=eDate.replace("T", " ");
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");	
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("")) {
                    list = stsfunc.getSpeedingDetails(systemId, Integer.parseInt(customerId),Integer.parseInt(branchId), date,eDate,offset,vehicleId);
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
            		request.getSession().setAttribute("startDate", sdf.format(df.parse(date)));
        	     	request.getSession().setAttribute("endDate",sdf.format(df.parse(eDate)));
        			response.getWriter().print(jsonObject.toString());
                  
                } else {
                    jsonObject.put("ViewRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            }catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
return null;
	}
}
