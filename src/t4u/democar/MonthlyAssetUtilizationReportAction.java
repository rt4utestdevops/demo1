package t4u.democar;

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
import t4u.functions.DemoCarFunctions;

public class MonthlyAssetUtilizationReportAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		
		String param = "";
		
		HttpSession session = ((HttpServletRequest) request).getSession();
		LoginInfoBean logininfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		
		int systemid = logininfo.getSystemId();
		int clientIdInt = logininfo.getCustomerId();		
		int offset = logininfo.getOffsetMinutes();
		String language = logininfo.getLanguage();
		int userId = logininfo.getUserId();

		DemoCarFunctions dcf = new DemoCarFunctions();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getData")) {

			String clientId = request.getParameter("custId");
			String groupId = request.getParameter("groupId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String gname = request.getParameter("gname");
			String jspName = request.getParameter("jspName");

			try {
				jsonObject = new JSONObject();
				if (clientId != null && groupId != null && !clientId.equals("") && !groupId.equals("")) {
					clientIdInt = Integer.parseInt(clientId);
					ArrayList list = dcf.getMonthlyAssetUtilityData(clientIdInt, systemid, groupId, startDate, endDate,offset, language, userId);
					jsonArray = (JSONArray) list.get(0);
					jsonObject.put("dardata", jsonArray);

					ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("gname", gname);
					request.getSession().setAttribute("sdate",cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
					request.getSession().setAttribute("edate",cf.getFormattedDateddMMYYYY(endDate.replaceAll("T"," ")));
				} else {
					jsonObject.put("dardata", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}