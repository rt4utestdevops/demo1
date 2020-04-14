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

public class DashBoardAction extends Action {
    public ActionForward execute(ActionMapping mapping, ActionForm form,
        HttpServletRequest request, HttpServletResponse response)
    throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        int custID = 0;

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
        custID =  loginInfo.getCustomerId();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if(param.equalsIgnoreCase("getFollowUps")) {
  	    	try {  	            
  	    		 
  	            	jsonArray = new JSONArray(); 
  	            	int usrId;
  	            	if(request.getParameter("ussrId")==null || request.getParameter("ussrId").equals("")) {
  	            		usrId=0;
  	            	}else{
  	            		usrId=Integer.parseInt(request.getParameter("ussrId"));
  	            	}
	  	            	jsonArray= cvmf.getFollowUps(systemId, usrId,custID);	  	            	
	  	                if (jsonArray.length() > 0) {
	  	                    jsonObject.put("followRoot", jsonArray);
	  	                } else {
	  	                    jsonObject.put("followRoot", "");
	  	                }
	  	                response.getWriter().print(jsonObject.toString());	  	               
  	            	
  	        } catch (Exception e) {
  	            e.printStackTrace();
  	        }  	    	
  	    }  		
  		else if (param.equalsIgnoreCase("getUserName")) {
            try {
                jsonArray = new JSONArray();
               
                    jsonArray = cvmf.getUserName(custID, systemId,loginInfo.getIsLtsp());
                    if (jsonArray.length() > 0) {
                        jsonObject.put("userRoot", jsonArray);
                    } else {
                        jsonObject.put("userRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
               
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
  	    
  	    else if (param.equalsIgnoreCase("getNumVisits")) {
                try {
                    int usrId;
  	            	if(request.getParameter("ussrId")==null || request.getParameter("ussrId").equals("")) {
  	            		usrId=0;
  	            	}else{
  	            		usrId=Integer.parseInt(request.getParameter("ussrId"));
  	            	}
                    jsonArray = new JSONArray();
                       
                        jsonArray = cvmf.getNumVisits(custID, systemId,usrId);
                        if (jsonArray.length() > 0) {
                            jsonObject.put("numVisitRoot", jsonArray);
                        } else {
                            jsonObject.put("numVisitRoot", "");
                        }
                        response.getWriter().print(jsonObject.toString());                       
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
		else if (param.equalsIgnoreCase("getVisitDetails")) {
            try {                
                jsonArray = new JSONArray();
                int usrId=Integer.parseInt(request.getParameter("usrid"));
                ArrayList < Object > list1 = cvmf.getVisitDetails(systemId, usrId,offset);
                    jsonArray = (JSONArray) list1.get(0);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("visitRoot", jsonArray);
                    } else {
                        jsonObject.put("visitRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());               
            } catch (Exception e) {
                e.printStackTrace();
            }       
        }
		else if(param.equalsIgnoreCase("getPendingFollowUps")) {
  	    	try {  	            
  	            	jsonArray = new JSONArray(); 
  	            	int usrId;
  	            	if(request.getParameter("ussrId")==null || request.getParameter("ussrId").equals("")) {
  	            		usrId=0;
  	            	}else{
  	            		usrId=Integer.parseInt(request.getParameter("ussrId"));
  	            	}
	  	            	jsonArray= cvmf.getPendingFollowUps(systemId, usrId ,custID);	  	            	
	  	                if (jsonArray.length() > 0) {
	  	                    jsonObject.put("pendingRoot", jsonArray);
	  	                } else {
	  	                    jsonObject.put("pendingRoot", "");
	  	                }
	  	                response.getWriter().print(jsonObject.toString());  	            	
  	        } catch (Exception e) {
  	            e.printStackTrace();
  	        }  	    	
  	    }
		else if(param.equalsIgnoreCase("getPendingFollowUp")) {
  	    	try {  	            
  	            	jsonArray = new JSONArray(); 
  	            	int usrId;
  	            	if(request.getParameter("ussrId")==null || request.getParameter("ussrId").equals("")) {
  	            		usrId=0;
  	            	}else{
  	            		usrId=Integer.parseInt(request.getParameter("ussrId"));
  	            	}
	  	            	jsonArray= cvmf.getPendingFollowUp(systemId, usrId ,custID);	  	            	
	  	                if (jsonArray.length() > 0) {
	  	                    jsonObject.put("pendingFollowUpRoot", jsonArray);
	  	                } else {
	  	                    jsonObject.put("pendingFollowUpRoot", "");
	  	                }
	  	                response.getWriter().print(jsonObject.toString());  	            	
  	        } catch (Exception e) {
  	            e.printStackTrace();
  	        }  	    	
  	    }
		else if(param.equalsIgnoreCase("getTotalFollowUp")) {
  	    	try {  	            
  	            	jsonArray = new JSONArray(); 
  	            	int usrId;
  	            	if(request.getParameter("ussrId")==null || request.getParameter("ussrId").equals("")) {
  	            		usrId=0;
  	            	}else{
  	            		usrId=Integer.parseInt(request.getParameter("ussrId"));
  	            	}
	  	            	jsonArray= cvmf.getTotalFollowUp(systemId, usrId ,custID);	  	            	
	  	                if (jsonArray.length() > 0) {
	  	                    jsonObject.put("totalFollowUpRoot", jsonArray);
	  	                } else {
	  	                    jsonObject.put("totalFollowUpRoot", "");
	  	                }
	  	                response.getWriter().print(jsonObject.toString());  	            	
  	        } catch (Exception e) {
  	            e.printStackTrace();
  	        }  	    	
  	    }
        
		else if(param.equalsIgnoreCase("getCommunicatingFollowUps")) {
  	    	try {
  	            	jsonArray = new JSONArray(); 
  	            	int usrId;
  	            	if(request.getParameter("ussrId")==null || request.getParameter("ussrId").equals("")) {
  	            		usrId=0;
  	            	}else{
  	            		usrId=Integer.parseInt(request.getParameter("ussrId"));
  	            	}
	  	            	jsonArray= cvmf.getCommunicatingFollowUps(systemId, usrId ,custID);	  	            	
	  	                if (jsonArray.length() > 0) {
	  	                    jsonObject.put("pendingRoot2", jsonArray);
	  	                } else {
	  	                    jsonObject.put("pendingRoot2", "");
	  	                }
	  	                response.getWriter().print(jsonObject.toString());  	            	
  	        } catch (Exception e) {
  	            e.printStackTrace();
  	        }  	    	
  	    }
        
     return null;
    }
    

}