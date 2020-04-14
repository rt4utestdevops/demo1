package t4u.Billing;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.functions.BillingFunctions;
import t4u.functions.CommonFunctions;

public class VehicleGroupingForBilling  extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
	   CommonFunctions cf = new CommonFunctions();
	   BillingFunctions billing= new BillingFunctions();
	   JSONArray jsonArray = null;
	   JSONObject jsonObject = new JSONObject();
	   
	   if (param.equals("getLtsp")) {
	        try {
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            jsonArray = billing.getLtsp(0);
	            if (jsonArray.length() > 0) {
	                jsonObject.put("lpstRoot", jsonArray);
	            } else {
	                jsonObject.put("lpstRoot", "");
	            }
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } else if (param.equals("getCustomer")){
			String ltspSystemId = request.getParameter("systemId") != null&& !request.getParameter("systemId").equals("") ? request.getParameter("systemId") : "0";
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			try {
				jsonArray = cf.getCustomersForLTSP(Integer.parseInt(ltspSystemId));				
				if(jsonArray.length()>0){
					jsonObject.put("CustomerRoot",jsonArray);
				}else{
					jsonObject.put("CustomerRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
		
	    }else if(param.equals("getGroup")){

			String custId = request.getParameter("CustId") != null&& !request.getParameter("CustId").equals("") ? request.getParameter("CustId") : "0";
			String ltspSystemId = request.getParameter("systemId") != null&& !request.getParameter("systemId").equals("") ? request.getParameter("systemId") : "0";
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			try {
				jsonArray = billing.getGroup(Integer.parseInt(ltspSystemId),Integer.parseInt(custId));				
				if(jsonArray.length()>0){
					jsonObject.put("groupRoot",jsonArray);
				}else{
					jsonObject.put("groupRoot","");
				}
				response.getWriter().print(jsonObject.toString());	
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
	    else if(param.equals("saveGroupDetails")){
		     try {
		    	 String custId = request.getParameter("custId") != null&& !request.getParameter("custId").equals("") ? request.getParameter("custId") : "0";
		    	 String sysId = request.getParameter("systemId") != null&& !request.getParameter("systemId").equals("") ? request.getParameter("systemId") : "0";
		    	 String groupAddress = request.getParameter("groupAddress");
		    	 String groupName= request.getParameter("groupName");;
		         String message ="";
	             message = billing.saveGroupDetails(custId,sysId,groupAddress,groupName);
		         response.getWriter().print(message);
	         } catch (Exception e) {
	        	 System.out.println("Error in saving group details "+e.toString());
	            e.printStackTrace();
	         }
	    }else if(param.equals("getDataForNonAssociation")){
            try {
                String custId = request.getParameter("CustId") != null&& !request.getParameter("CustId").equals("") ? request.getParameter("CustId") : "0";
                String systemID = request.getParameter("systemId") != null&& !request.getParameter("systemId").equals("") ? request.getParameter("systemId") : "0";
                String groupId = request.getParameter("groupId") != null&& !request.getParameter("groupId").equals("") ? request.getParameter("groupId") : "0";
                jsonArray = new JSONArray();
                ArrayList < Object > list1 = billing.getDataForNonAssociation(Integer.parseInt(custId), Integer.parseInt(systemID), Integer.parseInt(groupId));
                jsonArray = (JSONArray) list1.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("firstGridRoot", jsonArray);
 	               } else {
                    jsonObject.put("firstGridRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }else if(param.equals("getDataForAssociation")){
            try {
                String custId = request.getParameter("CustId") != null&& !request.getParameter("CustId").equals("") ? request.getParameter("CustId") : "0";
                String systemID = request.getParameter("systemId") != null&& !request.getParameter("systemId").equals("") ? request.getParameter("systemId") : "0";
                String groupId = request.getParameter("groupId") != null&& !request.getParameter("groupId").equals("") ? request.getParameter("groupId") : "0";
                jsonArray = new JSONArray();
                ArrayList < Object > list1 = billing.getDataForAssociation(Integer.parseInt(custId), Integer.parseInt(systemID), Integer.parseInt(groupId));
                jsonArray = (JSONArray) list1.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("secondGridRoot", jsonArray);
 	               } else {
                    jsonObject.put("secondGridRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        else if (param.equalsIgnoreCase("associateGroup")) {
            String message = "";
            String s = request.getParameter("gridData");
            String systemID = request.getParameter("systemId") != null&& !request.getParameter("systemId").equals("") ? request.getParameter("systemId") : "0";
            String customerId = request.getParameter("custId") != null&& !request.getParameter("custId").equals("") ? request.getParameter("custId") : "0";
            String groupId = request.getParameter("groupId") != null&& !request.getParameter("groupId").equals("") ? request.getParameter("groupId") : "0";
            try {
                if (s != null) {
                    String st = "[" + s + "]";
                    JSONArray js = null;
                    try {
                        js = new JSONArray(st.toString());
                        if (js.length() > 0) {
                            message = billing.associateGroup(Integer.parseInt(customerId), Integer.parseInt(systemID), Integer.parseInt(groupId), js);
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
        else if (param.equalsIgnoreCase("dissociateGroup")) {
        	String message = "";
            String s = request.getParameter("gridData2");
            String systemID = request.getParameter("systemId") != null&& !request.getParameter("systemId").equals("") ? request.getParameter("systemId") : "0";
            String customerId = request.getParameter("custId") != null&& !request.getParameter("custId").equals("") ? request.getParameter("custId") : "0";
            String groupId = request.getParameter("groupId") != null&& !request.getParameter("groupId").equals("") ? request.getParameter("groupId") : "0";
            try {
                if (s != null) {
                    String st = "[" + s + "]";
                    JSONArray js = null;
                    try {
                        js = new JSONArray(st.toString());
                        if (js.length() > 0) {
                            message = billing.dissociateGroup(Integer.parseInt(customerId), Integer.parseInt(systemID), Integer.parseInt(groupId), js);
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

		return null;
		
	}
}
