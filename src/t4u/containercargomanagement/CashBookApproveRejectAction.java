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

public class CashBookApproveRejectAction extends Action {
	
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		HttpSession session = request.getSession();
		LoginInfoBean logInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = logInfoBean.getSystemId();
		int customerId = logInfoBean.getCustomerId();
		int userId = logInfoBean.getUserId();
		int offset = logInfoBean.getOffsetMinutes();
		int isLtsp = logInfoBean.getIsLtsp();
		String language = logInfoBean.getLanguage();
		ContainerCargoManagementFunctions ccmFunc = new ContainerCargoManagementFunctions();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		
		String param = "";
		
		if(request.getParameter("param") != null) {
			param = request.getParameter("param");
		}
		
		if(param.equals("getBranchList")) {
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
//				System.out.println("userBranchRoot : "+jsonArray.toString());
				response.getWriter().print(jsonObject.toString());
		} else if(param.equals("getCashBookDetails")) {
			String custId = request.getParameter("custId");
			String status = request.getParameter("status");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String jspName = request.getParameter("jspName");
			String branchId = request.getParameter("branchId");
			String branchName = request.getParameter("branchName");

			ArrayList<Object> cashBookList = ccmFunc.getCashBookApproveRejectDetails(systemId, custId, userId, status, offset, startDate, endDate, language, branchId);
			if(cashBookList != null) {
				jsonArray = (JSONArray)cashBookList.get(0);
				if(jsonArray.length() > 0) {
					jsonObject.put("cashBookRoot", jsonArray);
					ReportHelper reportHelper = (ReportHelper) cashBookList.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("status", status);
					request.getSession().setAttribute("branch", branchName);
					request.getSession().setAttribute("startDate", startDate);
					request.getSession().setAttribute("endDate", endDate);
				} else {
					jsonObject.put("cashBookRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
		} else if(param.equals("approveCashBookAmount")) {
			String uniqueId = request.getParameter("uniqueId");
			String transacType = request.getParameter("transacType");
			String branchId = request.getParameter("branchId");
			String transacDate = request.getParameter("transacDate");
			double amount = 0;
			double appAmount = 0;
			
			if(request.getParameter("amount") != null && !request.getParameter("amount").equals("undefined")) {
				amount = Double.parseDouble(request.getParameter("amount"));
			}
			if(request.getParameter("appAmount") != null && !request.getParameter("appAmount").equals("undefined")) {
				appAmount = Double.parseDouble(request.getParameter("appAmount"));
			}
			
			String message = "";
			if(transacType.equals("Debit") && (appAmount > amount)){
				message = "Approved Amount Can Not Be Greater Than Amount.";
			} else {
				message = ccmFunc.approveCashBook(systemId, customerId, uniqueId, transacType, amount, appAmount, userId, offset, branchId, transacDate);
			}
			response.getWriter().print(message);
			
		} else if(param.equals("rejectCashBookAmount")) {
			String uniqueId = request.getParameter("uniqueId");
			String transacType = request.getParameter("transacType");
			String branchId = request.getParameter("branchId");
			String transacDate = request.getParameter("transacDate");
			double amount = 0;
			double appAmount = 0;
			
			if(request.getParameter("amount") != null && !request.getParameter("amount").equals("undefined") && !request.getParameter("amount").equals("")) {
				amount = Double.parseDouble(request.getParameter("amount"));
			}
			if(request.getParameter("appAmount") != null && !request.getParameter("appAmount").equals("undefined") && !request.getParameter("appAmount").equals("")) {
				appAmount = Double.parseDouble(request.getParameter("appAmount"));
			}
			String message = "";
			
			if(appAmount > 0){
				message = "Approved Amount Can not be Greate Than Zero.";
			} else {
				message = ccmFunc.rejectCashBook(systemId, customerId, uniqueId, transacType, amount, appAmount, userId, offset, branchId, transacDate);
			}

			response.getWriter().print(message);
		}
		return null;
	}

}
