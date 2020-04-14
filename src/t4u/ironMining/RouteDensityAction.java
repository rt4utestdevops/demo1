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
import t4u.functions.IronMiningFunction;

public class RouteDensityAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) {
		try {
			HttpSession session = request.getSession();
			String param = "";
			int systemId = 0;
			int customerId = 0;
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			if (loginInfo != null) {
				systemId = loginInfo.getSystemId();
				customerId = loginInfo.getCustomerId();
				int userId = loginInfo.getUserId();
				String lang = loginInfo.getLanguage();
				IronMiningFunction ironMiningFunction = new IronMiningFunction();
				JSONArray jsonArray = null;
				JSONObject jsonObject = null;
				if (request.getParameter("param") != null) {
					param = request.getParameter("param").toString();
				}
				if (param.equalsIgnoreCase("getRouteDetails")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						customerId=Integer.parseInt(request.getParameter("CustId"));
						String custName=request.getParameter("custName");
						String jspName=request.getParameter("jspName");
	                    ArrayList < Object > list=ironMiningFunction.getRouteDensityDetails(systemId,customerId,userId);
	                    jsonArray = (JSONArray) list.get(0);
	                    if (jsonArray.length() > 0) {
							jsonObject.put("routeDensityRoot", jsonArray);
						} else {
							jsonObject.put("routeDensityRoot", "");
						}
	                    ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custId", custName);
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						System.out.println("Error....");
						e.printStackTrace();
					}
				}else if (param.equalsIgnoreCase("getRouteTripDetails")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						int routeId=0;
						if(request.getParameter("routeId")!=null){
							routeId=Integer.parseInt(request.getParameter("routeId"));
						}
						String jspName=request.getParameter("jspName");
	                    ArrayList < Object > list=ironMiningFunction.getRouteTripDetails(systemId,customerId,userId,routeId);
	                    jsonArray = (JSONArray) list.get(0);
	                    if (jsonArray.length() > 0) {
							jsonObject.put("routeTripDetailsRoot", jsonArray);
						} else {
							jsonObject.put("routeTripDetailsRoot", "");
						}
	                    ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custId", "");
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						System.out.println("Error....");
						e.printStackTrace();
					}
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

}
