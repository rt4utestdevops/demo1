package t4u.GeneralVertical;

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
import t4u.functions.CommonFunctions;
import t4u.functions.GeneralVerticalFunctions;

public class UserCustomerAssociationAction extends Action{
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	HttpSession session = request.getSession();
    String param = "";
    int systemId = 0;
    int userId = 0;
	int clientId = 0;
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    systemId = loginInfo.getSystemId();
    userId = loginInfo.getUserId();
	clientId = loginInfo.getCustomerId();
    String serverName=request.getServerName();
    String sessionId = request.getSession().getId();
    GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();
    JSONArray jsonArray = null;
    JSONObject jsonObject = new JSONObject();
    if (request.getParameter("param") != null) {
        param = request.getParameter("param").toString();
    }	
	
    if (param.equals("getUsersBasedOnCustomer")) {
        try {
            jsonArray = new JSONArray();
            jsonObject = new JSONObject();
            String custId = "0";
            if (request.getParameter("CustId") != null) {
                custId = request.getParameter("CustId");
            }
            jsonArray = gvf.getUsersBasedOnCustomer(systemId, Integer.parseInt(custId));
            if (jsonArray.length() > 0) {
                jsonObject.put("userRoot", jsonArray);
            } else {
                jsonObject.put("userRoot", "");
            }
            response.getWriter().print(jsonObject.toString());
            CommonFunctions cf=new CommonFunctions();
            cf.insertDataIntoAuditLogReport(sessionId, null, "User Trip Customer Association", "View", userId, serverName, systemId, clientId,
			"Visited This Page");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    else if (param.equalsIgnoreCase("getDataForNonAssociation")) {
        try {
            String customerId = request.getParameter("CustId");
            String userIdFromjsp = request.getParameter("userIdFromJsp");
            jsonArray = new JSONArray();
            if (customerId != null && !customerId.equals("") && userIdFromjsp != null && !userIdFromjsp.equals("")) {
                ArrayList < Object > list1 = gvf.getDataForNonAssociation(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromjsp));
                jsonArray = (JSONArray) list1.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("firstGridRoot", jsonArray);
                } else {
                    jsonObject.put("firstGridRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } else {
                jsonObject.put("firstGridRoot", "");
                response.getWriter().print(jsonObject.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }	
	
    else if (param.equalsIgnoreCase("getDataForAssociation")) {
        try {
            String customerId = request.getParameter("CustId");
            String userIdFromjsp = request.getParameter("userIdFromJsp");
            jsonArray = new JSONArray();
            if (customerId != null && !customerId.equals("") && userIdFromjsp != null && !userIdFromjsp.equals("")) {
                ArrayList < Object > list1 = gvf.getDataForAssociation(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromjsp));
                jsonArray = (JSONArray) list1.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("secondGridRoot", jsonArray);
                } else {
                    jsonObject.put("secondGridRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } else {
                jsonObject.put("secondGridRoot", "");
                response.getWriter().print(jsonObject.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }	
	
    else if (param.equalsIgnoreCase("associateCustomer")) {
        String message = "";
        String customerId = request.getParameter("CustID");
        String s = request.getParameter("gridData");
        String userIdFromJsp = request.getParameter("userIdFromJsp");
        String pageName=request.getParameter("pageName");
        try {
            if (s != null) {
                String st = "[" + s + "]";
                JSONArray js = null;
                try {
                    js = new JSONArray(st.toString());
                    if (js.length() > 0) {
                        message = gvf.associateCustomer(Integer.parseInt(customerId), systemId,Integer.parseInt(userIdFromJsp), js,userId,pageName,sessionId,serverName);
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

    else if (param.equalsIgnoreCase("dissociateCustomer")) {
        String message = "";
        String customerId = request.getParameter("CustID");
        String s = request.getParameter("gridData2");
        String userIdFromJsp = request.getParameter("userIdFromJsp");
        String pageName=request.getParameter("pageName");
        try {
            if (s != null) {
                String st = "[" + s + "]";
                JSONArray js = null;
                try {
                    js = new JSONArray(st.toString());
                    if (js.length() > 0) {
                        
                        message = gvf.dissociateCustomer(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromJsp), js,userId,pageName,sessionId,serverName);
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