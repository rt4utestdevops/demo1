package t4u.FFM;

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
import t4u.functions.FFMFunctions;

public class FFMCustomerAppointmentAction extends Action {
    public ActionForward execute(ActionMapping mapping, ActionForm form,
        HttpServletRequest request, HttpServletResponse response)
    throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;

        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        FFMFunctions cvmf = new FFMFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if (param.equalsIgnoreCase("getCustomerForAppt")) {
            try {
      	         String custID = request.getParameter("custId");
       	         jsonArray = new JSONArray();
       	         if (custID != null && !custID.equals("")) {           
       	        	jsonArray = cvmf.getCustomerForAppt(Integer.parseInt(custID), systemId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("ffmcustomerRoot", jsonArray);
	                } else {
	                    jsonObject.put("ffmcustomerRoot", "");
	                }
       	        }else {
                    jsonObject.put("customerRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
               
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 		
  		else if (param.equalsIgnoreCase("getSupervisor")) {
                try {
                	 String custID = request.getParameter("custId");
          	         jsonArray = new JSONArray();
          	         if (custID != null && !custID.equals("")) {                         
	                    jsonArray = cvmf.getSupervisorName(Integer.parseInt(custID), systemId);
	                    if (jsonArray.length() > 0) {
	                        jsonObject.put("supervisorRoot", jsonArray);
	                    } else {
	                        jsonObject.put("supervisorRoot", "");
	                    }
	                }else {
	                    jsonObject.put("customerRoot", "");
	                }
                    response.getWriter().print(jsonObject.toString());                       
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
		else if(param.equalsIgnoreCase("getEmployees")) {
  	    	try {  	            
  	    		String custID = request.getParameter("custId");
     	        jsonArray = new JSONArray();
     	        if (custID != null && !custID.equals("")) {          	
     	        	jsonArray= cvmf.getEmployees(systemId, Integer.parseInt(custID));	  	            	
		            if (jsonArray.length() > 0) {
		                jsonObject.put("employeeRoot", jsonArray);
		            } else {
		                jsonObject.put("employeeRoot", "");
		            }
     	         }else {
 	                jsonObject.put("employeeRoot", "");
 	            }
	  	      	response.getWriter().print(jsonObject.toString());  	            	
  	        } catch (Exception e) {
  	            e.printStackTrace();
  	        }  	    	
  	    }
      	else if (param.equalsIgnoreCase("appointmentAddAndModify")) {
            try {

                String buttonValue = request.getParameter("buttonValue");
                String custID =  request.getParameter("custId");
                String appointmentTime= request.getParameter("appointmentTime");
                String remark = request.getParameter("remark");
                String followUpDate =request.getParameter("followUpDate");
                String message="";
                if (custID != null && !custID.equals("")) { 
	                if (buttonValue.equals("Add")) {
	                	int custName = Integer.parseInt(request.getParameter("custName"));
	                    int supervisor = Integer.parseInt(request.getParameter("supervisor"));
	                    int empUser=Integer.parseInt(request.getParameter("empUser"));
	                    String employee=request.getParameter("employee");
	                    int status=Integer.parseInt(request.getParameter("status"));
	                    message = cvmf.insertAppointment(custName,supervisor,employee,offset,appointmentTime,remark,followUpDate,systemId,Integer.parseInt(custID),status,empUser);	                   
	                } else if (buttonValue.equals("Modify")) {
	                	int uniqueId=Integer.parseInt(request.getParameter("uniqueId"));
	                	int custNameModify = Integer.parseInt(request.getParameter("custNameModify"));
	                    int supervisorModify = Integer.parseInt(request.getParameter("supervisorModify"));
	                    int empUserModify=Integer.parseInt(request.getParameter("empUserModify"));
	                    String employeeModify=request.getParameter("employeeModify");
	                    int statusModify=Integer.parseInt(request.getParameter("statusModify"));
	                    message = cvmf.modifyAppointment(uniqueId,custNameModify,supervisorModify,employeeModify,offset,appointmentTime,remark,followUpDate,systemId,Integer.parseInt(custID),statusModify,empUserModify);
	                }
	                response.getWriter().print(message);
                } 
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
		 else if (param.equalsIgnoreCase("getAppointmentDetails")) {
       	     try {
	       	    	String custID = request.getParameter("custId");
	       	    	String startDate=request.getParameter("startdate");
	       	    	String endDate=request.getParameter("enddate");
	     	        jsonArray = new JSONArray();
	     	        if (custID != null && !custID.equals("")) {
	       	             ArrayList < Object > list1 = cvmf.getAppointmentDetails(Integer.parseInt(custID), systemId,offset,startDate,endDate);
	       	             jsonArray = (JSONArray) list1.get(0);
	       	             if (jsonArray.length() > 0) {
	       	                 jsonObject.put("appointmentRoot", jsonArray);
	       	             } else {
	       	                 jsonObject.put("appointmentRoot", "");
	       	             }
	       	             response.getWriter().print(jsonObject.toString());	       	         
     	        }	     	       
       	     } catch (Exception e) {
       	         e.printStackTrace();
       	     }
       	 }
     	else if (param.equalsIgnoreCase("deleteAppointmentData")) {
            try {            	
                int uniqueId = Integer.parseInt(request.getParameter("uniqueId"));
       	    	String custID = request.getParameter("custId");
     	        jsonArray = new JSONArray();
     	        if (custID != null && !custID.equals("")) {
	                String message = "Could Not Delete Data";              
	                message = cvmf.deleteAppointmentData(Integer.parseInt(custID), systemId,uniqueId);                
	                response.getWriter().print(message);
     	        }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }        
        return null;
    }

}