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
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.FFMFunctions;

public class CustomerVisitHistoryAction extends Action {

    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
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
        FFMFunctions cvh = new FFMFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        CommonFunctions cf = new CommonFunctions();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }

        if (param.equalsIgnoreCase("getCustomerHistory")) {
            try {
                String startDate = request.getParameter("startdate");
                String endDate = request.getParameter("enddate");
                String jspName = request.getParameter("jspName");
                
                    ArrayList < Object > list = cvh.getCustomerHistoryDetails(systemId, startDate, endDate, offset, lang);
                    jsonArray = (JSONArray) list.get(0);
                    if (jsonArray != null) {
                        if (jsonArray.length() > 0)
                            jsonObject.put("customerVisitHistoryRoot", jsonArray);
                    } else {
                        jsonObject.put("customerVisitHistoryRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                    ReportHelper reportHelper = (ReportHelper) list.get(1);
                    request.getSession().setAttribute(jspName, reportHelper);
                    request.getSession().setAttribute("startDate", cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
                    request.getSession().setAttribute("endDate", cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));

               

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}