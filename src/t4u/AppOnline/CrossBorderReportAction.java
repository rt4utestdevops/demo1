package t4u.AppOnline;

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
import t4u.functions.ApOnlineFunctions;
import t4u.functions.CommonFunctions;

public class CrossBorderReportAction extends Action{
	
public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();

		String param = "";
		int systemId = 0;
		int clientId = 0;
        int userId=0;
        
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		userId=loginInfo.getUserId();
        
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }	
	
		if (param.equalsIgnoreCase("getCrossedBroderOrderReport")) {
			
			JSONArray jsonArray = null;
			JSONObject jsonObject = new JSONObject();

			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String jspName = request.getParameter("jspName");

			startDate = startDate.replace('T', ' ');
			endDate = endDate.replace('T', ' ');

			CommonFunctions cf = new CommonFunctions();
			ApOnlineFunctions func = new ApOnlineFunctions();
			
			try {
				ArrayList<Object> crossBorderReportDetails = func.getCrossBorderReportDetails(startDate, endDate, systemId, clientId,userId);
				jsonArray = (JSONArray) crossBorderReportDetails.get(0);
				
				if (jsonArray.length() > 0) {
					jsonObject.put("crossBorderRoot", jsonArray);
				} else {
					jsonObject.put("crossBorderRoot", "");
				}
				
				ReportHelper reportHelper = (ReportHelper) crossBorderReportDetails.get(1);
				session.setAttribute(jspName, reportHelper);
				session.setAttribute("startdate", startDate);
				session.setAttribute("enddate", endDate);
				session.setAttribute("customerName", cf.getCustomerName(String.valueOf(clientId), systemId));
				response.getWriter().print(jsonObject.toString());
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	  return null;
	}
}

