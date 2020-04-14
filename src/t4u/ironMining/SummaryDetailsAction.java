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
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class SummaryDetailsAction extends Action{

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String message="";
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		
		if (param.equalsIgnoreCase("getSummarDetails")) {
			try {
				ArrayList list=null;
				String CustomerId = request.getParameter("CustID");
				String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
				String tcNum=request.getParameter("TcNum");
				String monthYear=request.getParameter("MonthYear");
				String[]a=monthYear.split("/");
				String month=a[0].trim();
				//System.out.println("CustomerId:"+CustomerId+"jspName:"+jspName);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list =ironfunc.getSummaryDetails(customerName,systemId, Integer.parseInt(CustomerId),month,tcNum,lang);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("challanDetailsRoot", jsonArray);
					} else {
						jsonObject.put("challanDetailsRoot", "");
					}
					reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName,reportHelper);
					request.getSession().setAttribute("custId", customerName);
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("challanDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}