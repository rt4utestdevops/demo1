package t4u.sandmining;

import java.text.SimpleDateFormat;
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
import t4u.functions.SandMiningFunctions;

public class Sand_Mining_Yearly_Report_Action extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String param = "";
		int offmin = 0;
		int systemId = 0;
		int userId = 0;
		int clientId=0;
		String lang = "";
		String Zone = "";
		SimpleDateFormat sdfddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
		HttpSession session = request.getSession();
		CommonFunctions cf = new CommonFunctions();
		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		SandMiningFunctions sandfunc = new SandMiningFunctions();
		systemId = loginInfo.getSystemId();
		clientId=loginInfo.getCustomerId();
		userId = loginInfo.getUserId();
		offmin = loginInfo.getOffsetMinutes();
		int offset = loginInfo.getOffsetMinutes();
		Zone = loginInfo.getZone();
		lang = loginInfo.getLanguage();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if(param.equals("getPermitNo"))
		{
			try{
				String clientIdFromJsp = request.getParameter("CustId");
				if(clientIdFromJsp != null)
				{
					clientId = Integer.parseInt(clientIdFromJsp);	
				}
				jsonArray = new JSONArray(); 
				jsonObject = new JSONObject();
				jsonArray = sandfunc.getPermitNo(systemId,clientId,userId);	
				if (jsonArray.length() > 0) {
				jsonObject.put("PermitNoStoreList", jsonArray);
				}
				else {
					jsonObject.put("PermitNoStoreList", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				System.out.println("Error in Common Action:-getPermitNo "
						+ e.toString());
			}
		}
		else if (param.equals("getYearlyPermitReport")) {
			try {
				String customerid = request.getParameter("CustID");
				String permitNo = request.getParameter("permitNo");
				String year = request.getParameter("year");
				String jspName = request.getParameter("jspName");
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				String str[] = year.split("-");
				String startYear = str[0];
				String endYear = str[1];
				ArrayList<Object> list1  = sandfunc.getYearlyPermitReport(	Integer.parseInt(customerid), startYear,endYear, systemId,permitNo);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("YearlyRevenueReport", jsonArray);
				} else {
					jsonObject.put("YearlyRevenueReport", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("TPNumber", permitNo);
				request.getSession().setAttribute("startdate", startYear);
				request.getSession().setAttribute("enddate", endYear);
				
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Yearly Revenue Report:"
						+ e.toString());
			}
		}
	
		return null;
	}
}
