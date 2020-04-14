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
import t4u.beans.ReportHelper;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class OverSpeedDebarringAction extends Action{
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	HttpSession session = request.getSession();
        String param = "";
        int systemId = 0;
        int custmerid = 0;
        int userId = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        custmerid = loginInfo.getCustomerId();
        userId = loginInfo.getUserId();
		IronMiningFunction ironfunc = new IronMiningFunction();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }	
    	
        if (param.equalsIgnoreCase("getOverSpeedDebarringDetails")) {
            try {
                String customerId = request.getParameter("CustId");
                String custName=request.getParameter("custName");
                String startDate=request.getParameter("startDate").substring(0,10);
                String endDate=request.getParameter("endDate").substring(0,10);
				String jspName=request.getParameter("jspName");
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("")) {
                    ArrayList < Object > list = ironfunc.getOverSpeedDebarringDetails(Integer.parseInt(customerId), systemId,startDate,endDate);
                    jsonArray = (JSONArray) list.get(0);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("getOverSpeedDebarringDetailsRoot", jsonArray);
     	               } else {
                        jsonObject.put("getOverSpeedDebarringDetailsRoot", "");
                    }
                    ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custName", custName);
					request.getSession().setAttribute("reportName", "Over Speed Debarring");
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("getOverSpeedDebarringDetailsRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        else if (param.equalsIgnoreCase("activeSelectedVehicles")) {
            String message = "";
            String customerId = request.getParameter("CustID");
            String s = request.getParameter("gridData");
            String remarks = request.getParameter("remarks");
            try {
                if (s != null) {
                    String st = "[" + s + "]";
                    JSONArray js = null;
                    try {
                        js = new JSONArray(st.toString());
                        if (js.length() > 0) {
                            message = ironfunc.makeActiveSelectedVehicles(Integer.parseInt(customerId), systemId, userId, js, remarks);
                        } else {
                            message = "";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    message = "";
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    	
		return null;
    }
}
