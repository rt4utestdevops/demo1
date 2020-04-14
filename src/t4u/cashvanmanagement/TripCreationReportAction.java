package t4u.cashvanmanagement;

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
import t4u.functions.TripCreationFunctions;

public class TripCreationReportAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		
		HttpSession session = request.getSession();		
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		
		int systemId = loginInfo.getSystemId();
		int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		
		CommonFunctions cf = new CommonFunctions();
		TripCreationFunctions tripcreationreport = new TripCreationFunctions();

		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("getTripCreationDetails")) {
			try {
				String jspName = request.getParameter("jspName");
				String customerid = request.getParameter("CustID");
				String startdate = request.getParameter("startdate");
				String enddate = request.getParameter("enddate");
				String zone = request.getParameter("zone");
				String custName = request.getParameter("custName");

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList list1 = tripcreationreport.getTripCreationDetails(customerid, startdate, enddate, systemId, offset, lang);
				jsonArray = (JSONArray) list1.get(0);

				if (jsonArray.length() > 0){
					jsonObject.put("tripreportroot", jsonArray);
				} else {
					jsonObject.put("tripreportroot", "");
				}

				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("customerid", custName);
				request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startdate.replaceAll("T"," ")));
				request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(enddate.replaceAll("T", " ")));
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
