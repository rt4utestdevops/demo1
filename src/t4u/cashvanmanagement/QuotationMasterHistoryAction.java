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
import t4u.functions.AdminFunctions;
import t4u.functions.CashVanManagementFunctions;


public class QuotationMasterHistoryAction extends Action{
	public ActionForward execute(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response){
		
		HttpSession session = request.getSession();
	    String param = "";
	    String zone = "";
	    int systemId = 0;
	    int userId = 0;
	    int offset = 0;
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    AdminFunctions adfunc = new AdminFunctions();
	    systemId = loginInfo.getSystemId();
	    zone = loginInfo.getZone();
	    userId = loginInfo.getUserId();
	    offset = loginInfo.getOffsetMinutes();
	    String lang = loginInfo.getLanguage();
	    String ltspName = loginInfo.getSystemName();
	    String userName = loginInfo.getUserFirstName()+" "+loginInfo.getUserLastName(); 
	    String category = loginInfo.getCategory();
	    String categoryType = loginInfo.getCategoryType();
	    CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
		if(param.equalsIgnoreCase("getQuoTationHistoryDetails")){
			try {
				String jspName = request.getParameter("jspName");
	            String customerId = request.getParameter("CustId");
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	                
	            	
	            	ArrayList < Object > list1 = cashVanfunc.getQuotationMasterHistoryDetails(systemId, Integer.parseInt(customerId));
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("customerMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("customerMasterRoot", "");
	                }
	         	   String custName2 = cashVanfunc.getCustomerName(systemId,Integer.parseInt(customerId));

					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerId", custName2);
	                
	                
	                
	            } else {
	                jsonObject.put("customerMasterRoot", "");
	            }
                response.getWriter().print(jsonObject.toString());

	        }catch (Exception e) {
				e.printStackTrace();
			}	
		}else if(param.equalsIgnoreCase("ApproveOrReject")){
			String message = "";
			 String customerId = request.getParameter("custId");
			 String quotationId = request.getParameter("quotationId");			 
			 String buttonValue = request.getParameter("buttonValue");
			 String statusType = request.getParameter("statusType");
			 String reason = request.getParameter("reason");
			 try{
			 message=cashVanfunc.ApproveOrRejection(Integer.parseInt(customerId),systemId,userId,Integer.parseInt(quotationId),buttonValue,statusType,reason);
			 //System.out.println("message == "+message);
			 response.getWriter().print(message);

			 }catch(Exception e){
				 e.printStackTrace();
			 }

			
		}
		
		
		return null;
	}
	
}
