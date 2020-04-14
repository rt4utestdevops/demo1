package t4u.fleetmaintance;
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
import t4u.functions.CargomanagementFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.FleetMaintanceFunctions;

public class FleetMaintanceAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
      
        String param = "";
		int systemId=0;
		int userId=0;
		int offset=0;
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		FleetMaintanceFunctions flfunc=new FleetMaintanceFunctions();
		systemId=loginInfo.getSystemId();
		userId=loginInfo.getUserId();
		offset=loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
         if(param.equals("getBranch"))
		{
			try
			{
				String clientId = request.getParameter("custId");
				jsonObject = new JSONObject();
				if(clientId != null && !clientId.equals(""))
				{
					jsonArray = flfunc.getBranches(systemId, Integer.parseInt(clientId),userId);	
					jsonObject.put("BranchStoreRoot", jsonArray);
				}
				else
				{
					jsonObject.put("BranchStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
         
         else if(param.equals("getData"))
 		{
 			try
 			{
 				String clientId = request.getParameter("CustId");
 				String branch=request.getParameter("branch");
 				String jspName=request.getParameter("jspName");
 				String custName=request.getParameter("custName");
 				JSONArray JsonArray = new JSONArray();
 				if(clientId != null && !clientId.equals(""))
 				{
 					ArrayList<Object> list1 = flfunc.getPartsPendingDetails(systemId, Integer.parseInt(clientId),userId,Integer.parseInt(branch),offset);	
 					JsonArray = (JSONArray) list1.get(0);
 					if (JsonArray.length() > 0) {
	                    jsonObject.put("PartsPendingApprovalRoot", JsonArray);
	                } else {
	                    jsonObject.put("PartsPendingApprovalRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custId", custName);
 				}
 				else
 				{
 					jsonObject.put("PartsPendingApprovalRoot", "");
 				}
 				response.getWriter().print(jsonObject.toString());
 			}
 			catch(Exception e){
 				e.printStackTrace();
 			}
 		}
				return null;
		
	}
}
	