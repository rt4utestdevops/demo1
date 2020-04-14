package t4u.cashvanmanagement;


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
import t4u.functions.CashVanManagementFunctions;

public class UserAuthorityAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		
		HttpSession session = request.getSession();		
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		
		CashVanManagementFunctions cashvanfunc = new CashVanManagementFunctions();

		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
	      if (param.equalsIgnoreCase("getUserDataDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =cashvanfunc.getUserDataDetails(customerId,systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("sourceUserStoreRoot", jsonArray);
					} else {
						jsonObject.put("sourceUserStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
		
	      else if (param.equalsIgnoreCase("userModify")) {
		        try {
		        	String UserId = request.getParameter("UserId");
		        	String ledgerauthority = request.getParameter("ledgerauthority");
		        	String cashview = request.getParameter("cashview");
		        	String reconcile = request.getParameter("reconcile");
		        	String writeOff = request.getParameter("writeOff");
		        	String reconcileHead = request.getParameter("reconcileHead");
		        	String message = "";
		        	message = cashvanfunc.userModify(Integer.parseInt(UserId),ledgerauthority,cashview,reconcile,customerId,systemId,userId,writeOff,reconcileHead);
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

		else if(param.equalsIgnoreCase("getUserAuthorityDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = cashvanfunc.getUserAuthorityDetails(customerId,systemId,offset);
				
				if (jsonArray.length() > 0){
					jsonObject.put("userauthorityroot", jsonArray);
				} else {
					jsonObject.put("userauthorityroot", "");
				}
               response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
