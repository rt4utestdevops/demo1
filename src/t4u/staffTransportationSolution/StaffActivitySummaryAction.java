package t4u.staffTransportationSolution;


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


public class StaffActivitySummaryAction  extends Action
{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   	 
	    	HttpSession session = request.getSession();
	        String param = "";
	        int systemId = 0;
	        int offset =0;
	        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	        systemId = loginInfo.getSystemId();
	        offset = loginInfo.getOffsetMinutes();
	        int userId = loginInfo.getUserId();
	        StaffTransportationSolutionFunctions stsfunc = new StaffTransportationSolutionFunctions();
	        JSONArray jsonArray = null;
	        JSONObject jsonObject = new JSONObject();
	        if (request.getParameter("param") != null) {
	            param = request.getParameter("param").toString();
	        }
	        
	        if(param.equals("getVehicleGroup")){
	    		try{
	    			
	    			String clientId = request.getParameter("clientId");
	    			   jsonObject = new JSONObject();
	    			   jsonArray = new JSONArray();
	    			if(clientId != null && !clientId.equals("")){			
	    				jsonArray = stsfunc.getVehicleGroup(systemId, Integer.parseInt(clientId));				
	    				jsonObject.put("GroupStoreRootUser", jsonArray);
	    			}else{
	    				jsonObject.put("GroupStoreRootUser", "");
	    			}			
	    			response.getWriter().print(jsonObject.toString());
	    		}
	    		catch(Exception e){
	    			e.printStackTrace();
	    		}
	    	}else if(param.equalsIgnoreCase("View")){

	    		try {
	                String customerId = request.getParameter("CustId");
	                String groupId = request.getParameter("GroupId");
	                String date = request.getParameter("Date");
	                String eDate = request.getParameter("endDate");
	                String jspName = request.getParameter("JspName");
	                String custName = request.getParameter("CustName");
	                String groupName =  request.getParameter("GroupName");
	                
	                jsonArray = new JSONArray();
	                
	                if (customerId != null && !customerId.equals("")) {
	                    ArrayList < Object > list = stsfunc.getStaffActivitySummaryDetails(systemId, Integer.parseInt(customerId),Integer.parseInt(groupId), date,eDate,offset, userId);
	                    if(list.size() > 0) {
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
	                    	request.getSession().setAttribute("groupName", groupName);
	                    	request.getSession().setAttribute("startDate", date);
	                    	request.getSession().setAttribute("endDate", eDate);
	                    	response.getWriter().print(jsonObject.toString()); 
	                    }
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
