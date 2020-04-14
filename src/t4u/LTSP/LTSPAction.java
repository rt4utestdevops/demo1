package t4u.LTSP;

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
import t4u.functions.LTSPFunctions;

public class LTSPAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int customerID = loginInfo.getCustomerId();
		int userID=loginInfo.getUserId();
		int offmin=loginInfo.getOffsetMinutes();
		int nonCommHrs=loginInfo.getNonCommHrs();
		LTSPFunctions ltspFunc = new LTSPFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if(param.equals("getClientList"))
		{

			try {
				String processID = request.getParameter("processId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(processID==null){
					String custName = request.getParameter("customername");
					jsonArray = ltspFunc.getCustStoreBasedOnCustName(custName,systemId, nonCommHrs);
				}else{
					jsonArray = ltspFunc.getClientList(processID,systemId, nonCommHrs);
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("ClientList", jsonArray);
				} else {
					jsonObject.put("ClientList", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		
		}else if(param.equals("getCommNonCommunicatingVehicles")){

			try {				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ltspFunc.getLstpDashboardCount(systemId,userID,nonCommHrs);
				if (jsonArray.length() > 0) {
					jsonObject.put("DashBoardElementCountRoot", jsonArray);
				} else {
					jsonObject.put("DashBoardElementCountRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		
		}
		if(param.equalsIgnoreCase("getCustomerNames"))
		{

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ltspFunc.getCustomerNames(systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("customernames", jsonArray);
				} else {
					jsonObject.put("customernames", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		
		}
		return null;
	}
}
