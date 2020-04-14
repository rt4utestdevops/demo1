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

public class AccountsHeadMasterAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		//String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getAccountsHeadMasterDetails")) {
	        try {
	        	ArrayList list=null;
	            String CustomerId = request.getParameter("CustId");
	    		
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	
	                list =ironfunc.getAccountsHeadMasterDetails(systemId, Integer.parseInt(CustomerId));
	                jsonArray = (JSONArray) list.get(0);
	            //    System.out.println(jsonArray.toString());
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("AccountsHeadMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("AccountsHeadMasterRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            	
	            } else {
	                jsonObject.put("AccountsHeadMasterRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		else if (param.equalsIgnoreCase("AddorModifyAccountsHeadDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String CustId=request.getParameter("CustId");
				String paymentHead=request.getParameter("paymentHead");
				String description=request.getParameter("description");
				String id= request.getParameter("id");
				String message="";
				if(buttonValue.equals("Add") && CustId != null && !CustId.equals(""))
				{
                     message=ironfunc.addAccountsHeadMasterdetails(paymentHead,description,systemId,Integer.parseInt(CustId));
				}else if(buttonValue.equals("Modify") && CustId != null && !CustId.equals(""))
				{
					message=ironfunc.modifyAccountsHeadMasterdetails(paymentHead,description,systemId,Integer.parseInt(CustId),Integer.parseInt(id));
				}
				
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
