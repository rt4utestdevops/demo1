package t4u.ironMining;

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
import t4u.functions.IronMiningFunction;

public class UserTcAssociationAction extends Action{
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
   	 
    	
    	HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int custmerid = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        AdminFunctions adfunc = new AdminFunctions();
        systemId = loginInfo.getSystemId();
        custmerid = loginInfo.getCustomerId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        String ltspName = loginInfo.getSystemName();
        String userName = loginInfo.getUserName();
        String category = loginInfo.getCategory();
        String categoryType = loginInfo.getCategoryType();
		IronMiningFunction ironfunc = new IronMiningFunction();
        CommonFunctions cf = new CommonFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }	
    	
        if (param.equals("getCustomer")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String ltsp1 = "no";
				if (request.getParameter("paramforltsp") != null) {
					ltsp1 = request.getParameter("paramforltsp").toString();
				}
				jsonArray = ironfunc.getCustomer(systemId, ltsp1, custmerid);
				if (jsonArray.length() > 0) {
					jsonObject.put("CustomerRoot", jsonArray);
				} else {
					jsonObject.put("CustomerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Common Action:-getCustomer "
						+ e.toString());
			}
		}
		else if (param.equals("getUsersBasedOnCustomer")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String custId = "0";
                if (request.getParameter("CustId") != null && request.getParameter("CustId") != "") {
                    custId = request.getParameter("CustId");
                }
                jsonArray = ironfunc.getUsersBasedOnCustomer(systemId, Integer.parseInt(custId));
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
        else if (param.equalsIgnoreCase("getDataForNonAssociation")) {
            try {
                String customerId = request.getParameter("CustId");
                String userIdFromjsp = request.getParameter("userIdFromJsp");
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("") && userIdFromjsp != null && !userIdFromjsp.equals("")) {
                    ArrayList < Object > list1 = ironfunc.getDataForNonAssociation(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromjsp));
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
                    ArrayList < Object > list1 = ironfunc.getDataForAssociation(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromjsp));
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
        else if (param.equalsIgnoreCase("associateGroup")) {
            String message = "";
            String customerId = request.getParameter("CustID");
            String s = request.getParameter("gridData");
            String userIdFromJsp = request.getParameter("userIdFromJsp");
            try {
                if (s != null) {
                    String st = "[" + s + "]";
                    JSONArray js = null;
                    try {
                        js = new JSONArray(st.toString());
                        if (js.length() > 0) {
                            message = ironfunc.associateGroup(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromJsp), js,userId);
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
            String customerId = request.getParameter("CustID");
            String s = request.getParameter("gridData2");
            String userIdFromJsp = request.getParameter("userIdFromJsp");
            try {
                if (s != null) {
                    String st = "[" + s + "]";
                    JSONArray js = null;
                    try {
                        js = new JSONArray(st.toString());
                        if (js.length() > 0) {
                            message = ironfunc.dissociateGroup(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromJsp), js,userId);
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
