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

public class ExpenseApprovalRejectAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		ContainerCargoManagementFunctions cfunc = new ContainerCargoManagementFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		String language = loginInfo.getLanguage();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("getExpenseDetails")) {
	        try {
	        	String status = request.getParameter("status");
	        	String startDate = request.getParameter("startDate");
	        	String endDate = request.getParameter("endDate");
	        	String jspName = request.getParameter("jspName");
	        	
	        	ArrayList list=null;
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            	
	                list =cfunc.getExpenseDetails(systemId, customerId, offset,status, startDate, endDate,language);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("expenseRoot", jsonArray);
	                    
	                    ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("status", status);
						request.getSession().setAttribute("sdate",startDate.replace("T", " "));
						request.getSession().setAttribute("edate",endDate.replace("T", " "));
	                } else {
	                    jsonObject.put("expenseRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            	
	            }
	         catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		
		else if(param.equals("getAccHeaderDetails")){
			try{
				jsonObject = new JSONObject();
				jsonArray = cfunc.getAccHeaderDetails(systemId,customerId);
				if(jsonArray.length() > 0){
					jsonObject.put("accHeaderStoreRoot", jsonArray);
				}else{
					jsonObject.put("accHeaderStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}		

	else if (param.equalsIgnoreCase("ApproveExpense")) {
		try {
				String buttonValue = request.getParameter("buttonValue");
				String uniqueId = request.getParameter("uniqueId");
				String tripNo = request.getParameter("tripNo");
				String tripDate = request.getParameter("tripDate");
				String amount = request.getParameter("amount");
				String description = request.getParameter("description");
				String appamount = request.getParameter("appamount");
				String accheader = request.getParameter("accheader");
				String remarks = request.getParameter("remarks");
				String branchId = request.getParameter("branchId");
				String driverId = request.getParameter("driverId");
				String addExpDate = request.getParameter("addExpDate");
				String assetNo = request.getParameter("assetNo");
				String message = "";	
				if (buttonValue.equals("Approve")) {						 
					message = cfunc.addApproveDetails(uniqueId, tripNo, tripDate, amount, description, appamount, accheader, remarks, branchId, driverId, userId, customerId, systemId, offset, addExpDate, assetNo);
				}
					response.getWriter().print(message);					 
				} catch (Exception e) {
					e.printStackTrace();
			}
		}	
	else if (param.equalsIgnoreCase("RejectExpense")) {
		try {
				String buttonValue = request.getParameter("buttonValue");
				String uniqueId = request.getParameter("uniqueId");
				String tripNo = request.getParameter("tripNo");
				String tripDate = request.getParameter("tripDate");
				String amount = request.getParameter("amount");
				String description = request.getParameter("description");
				String remarks = request.getParameter("remarks");
				String branchId = request.getParameter("branchId");
				String driverId = request.getParameter("driverId");
				String addExpDate = request.getParameter("addExpDate");
				String assetNo = request.getParameter("assetNo");
				String message = "";	
				if (buttonValue.equals("Reject")) {						 
							message = cfunc.addRejectDetails(uniqueId, tripNo, tripDate, amount, description, remarks, branchId, driverId, userId, customerId, systemId, offset, addExpDate, assetNo);
						}
							response.getWriter().print(message);					 
					} catch (Exception e) {
					e.printStackTrace();
				}
		} else if(param.equals("isInvoiceExists")) {
			String id = request.getParameter("id");
			
			JSONObject obj = cfunc.getAddExpDocuments( id );
			response.getWriter().print(obj.get("id"));
			
		} 		
		return null;
	}

}