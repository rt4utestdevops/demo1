package t4u.admin;

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
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;

public class OwnerMasterAction  extends Action {
	
 public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
   	 
    	
    	HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        AdminFunctions adfunc = new AdminFunctions();
        systemId = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        String ltspName = loginInfo.getSystemName();
        String userName = loginInfo.getUserName();
        String category = loginInfo.getCategory();
        String categoryType = loginInfo.getCategoryType();
        CommonFunctions cf = new CommonFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }	

	    if (param.equalsIgnoreCase("getOwnerMasterReport")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	                ArrayList < Object > list1 = adfunc.getOwnerMasterReport(systemId, Integer.parseInt(customerId));
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("ownerMastersRoot", jsonArray);
	                } else {
	                    jsonObject.put("ownerMastersRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("ownerMastersRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    else if (param.equalsIgnoreCase("ownerMasterAddAndModify")) {
	        try {
	            String custId = request.getParameter("CustId");
	            String buttonValue = request.getParameter("buttonValue");
	            String firstName = request.getParameter("firstName");
	            String lastName = request.getParameter("lastName");
	            String address = request.getParameter("address");
	            String emailId = request.getParameter("emailId");
	            String phoneNo = request.getParameter("phoneNo");
	            String landlineNo = request.getParameter("landlineNo");
	            String id= request.getParameter("id");
	            
	            String gridFirstName = request.getParameter("gridFirstName");
                String gridLastName = request.getParameter("gridLastName");
                String gridAddress = request.getParameter("gridAddress");
                String gridEmailId = request.getParameter("gridEmailId");
                String gridPhoneNo = request.getParameter("gridPhoneNo");
                String gridLandLineno = request.getParameter("gridLandLineno");
	            
	            
	            String message="";
	            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = adfunc.insertOwnerInformation(Integer.parseInt(custId),firstName,lastName,address,emailId,phoneNo,landlineNo,systemId,userId);
	            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
	            	 if (!firstName.equals(gridFirstName) || !lastName.equals(gridLastName) || !address.equals(gridAddress) || !emailId.equals(gridEmailId) || !phoneNo.equals(gridPhoneNo) || !landlineNo.equals(gridLandLineno)) {
	                      message = adfunc.modifyOwnerInformation(Integer.parseInt(custId),firstName,lastName,address,emailId,phoneNo,landlineNo,systemId,Integer.parseInt(id));
	            	 } else {
	                     message = "<p>No Field Has Changed To Save</p>";
	                 }
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    else if (param.equals("deleteData")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String id = request.getParameter("id");
	            String message = "";
	            if (customerId != null && !customerId.equals("")) {
	                message = adfunc.deleteRecord(Integer.parseInt(customerId), systemId, Integer.parseInt(id));
	            }
                response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }	    
	    
        return null;
 }
 }
