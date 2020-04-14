package t4u.school;

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
import t4u.functions.SchoolFunctions;

public class SMSReportAction extends Action{

	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		
		String param = "";
		//int offset=0;
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		//int userId = loginInfo.getUserId();
		int systemId = loginInfo.getSystemId();
		int clientId = loginInfo.getCustomerId();
		String language = loginInfo.getLanguage();
		int offset = loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		
		SchoolFunctions schoolArrivalFunction = new SchoolFunctions();
		CommonFunctions commFunc = new CommonFunctions();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if (param.equals("getSMSReport")) {
			
			String jspName = request.getParameter("jspName");
			String startDate = request.getParameter("startdate").replace("T", " ");
			String endDate = request.getParameter("enddate").replace("T", " ");
			clientId= Integer.parseInt(request.getParameter("CustId"));
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				ArrayList<Object> schoolArrivalReportDetils = schoolArrivalFunction.getSMSReport(systemId, clientId,startDate,endDate,language,offset);
					
				jsonArray = (JSONArray) schoolArrivalReportDetils.get(0);
				
				if (jsonArray.length() > 0) {
					jsonObject.put("SMSReporRoot", jsonArray);
				} else {
					jsonObject.put("SMSReporRoot", "");
				}
				
				ReportHelper reportHelper = (ReportHelper) schoolArrivalReportDetils.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("startdate",startDate);
				request.getSession().setAttribute("enddate",endDate);
				request.getSession().setAttribute("customerName",commFunc.getCustomerName(String.valueOf(clientId), systemId));
				
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
