package t4u.Preferences;

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
import t4u.functions.PreferencesFunctions;

public class PreferencesAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String param = "";
	    String message = "";
	    String zone = "";
	    int systemId = 0;
	    int userId = 0;
	    int offset = 0;
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    PreferencesFunctions preference = new PreferencesFunctions();
	    systemId = loginInfo.getSystemId();
	    zone = loginInfo.getZone();
	    userId = loginInfo.getUserId();
	    offset = loginInfo.getOffsetMinutes();
	    String lang = loginInfo.getLanguage();
	    zone = loginInfo.getZone();
	    CommonFunctions cf = new CommonFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }

	    if (param.equalsIgnoreCase("getHolidaysReport")) {
	        try {
	            String customerId = request.getParameter("custID");
	            String startDate = request.getParameter("startdate");
	            String endDate = request.getParameter("enddate");
	            String custName = request.getParameter("custName");
	            String jspName = request.getParameter("jspName");

	            jsonArray = new JSONArray();

	            if (customerId != null && !customerId.equals("")) {
	                ArrayList < Object > list1 = preference.getPreferenceReport(systemId, Integer.parseInt(customerId), userId, lang, startDate, endDate, offset, zone);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("holidaysRoot", jsonArray);
	                } else {
	                    jsonObject.put("holidaysRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("customerId", custName);
	                request.getSession().setAttribute("startDate", cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
	                request.getSession().setAttribute("endDate", cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("holidaysRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	    }

	    if (param.equalsIgnoreCase("holidaysAddModify")) {
	        try {
	            String custId = request.getParameter("CustID");
	            String buttonValue = request.getParameter("buttonValue");
	            String date = request.getParameter("date");
	            String reasons = request.getParameter("reasons");
	            String id = request.getParameter("id");
	         
	            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = preference.insertPreferencesInformation(Integer.parseInt(custId), systemId, date, reasons, userId,offset);
	            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
	                message = preference.modifyPreferencesInformation(Integer.parseInt(id), Integer.parseInt(custId), systemId, date, reasons, userId,offset);
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    return null;
	}
	}