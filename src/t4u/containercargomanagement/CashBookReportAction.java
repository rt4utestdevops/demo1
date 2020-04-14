package t4u.containercargomanagement;

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
import t4u.functions.ContainerCargoManagementFunctions;

public class CashBookReportAction extends Action{

	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int isLtsp = loginInfo.getIsLtsp();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String language = loginInfo.getLanguage();
		
		ContainerCargoManagementFunctions ccmFunc = new ContainerCargoManagementFunctions();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		String param = "";
		
		if(request.getParameter("param") != null){
			param = request.getParameter("param");
		}

		if(param.equals("getBranchStore")) {
			String custId = request.getParameter("custId");
			
			if(isLtsp == 0) {
				jsonArray = ccmFunc.getBranch(systemId,custId);
			} else {
				jsonArray = ccmFunc.getUserBranchList(systemId, custId, userId);
			}
			if(jsonArray != null) {
				jsonObject.put("branchRoot", jsonArray);
			} else {
				jsonObject.put("branchRoot", "");
			}
//			System.out.println("userBranchRootReport : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
		} else if(param.equals("getTransactionTypeStore")) {
			String custId = request.getParameter("custId");
			jsonArray = ccmFunc.getTransactionTypeList(systemId, custId, userId);
			
			if(jsonArray != null) {
				JSONObject obj = new JSONObject();
				obj.put("transTypeID", 0);
				obj.put("transTypeName", "All");
				jsonArray.put(obj);
				jsonObject.put("transactionTypeRoot", jsonArray);
			} else {
				jsonObject.put("transactionTypeRoot", "");
			}
//			System.out.println("transactionTypeRootReport : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
		} else if(param.equals("getCashBookReportDetails")) {
			String custId = request.getParameter("custId");
			String branchId = request.getParameter("branchId");
			String transactionTypeId = request.getParameter("transactionTypeId");
			String year = request.getParameter("year");
			String jspName = request.getParameter("jspName");
			String transacType = request.getParameter("transacType");
			String branchName = request.getParameter("branchName");
			ArrayList<Object> cashBookReportList = ccmFunc.getCashBookReportDetails(systemId, custId, branchId, transactionTypeId, year, offset, language);
			
			if(cashBookReportList != null && cashBookReportList.size() > 0){
				jsonArray = (JSONArray)cashBookReportList.get(0);
				if(jsonArray.length() > 0) {
					
					jsonObject.put("cashBookReportRoot", jsonArray);

					ReportHelper reportHelper = (ReportHelper) cashBookReportList.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("branch",branchName);
					request.getSession().setAttribute("transacType", transacType);
					request.getSession().setAttribute("year", year);
				} else {
					jsonObject.put("cashBookReportRoot", "");
				}
			} else {
				jsonObject.put("cashBookReportRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
		}
		
		return null;
	}
}
