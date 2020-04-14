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

public class MotherRouteMasterAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		IronMiningFunction ironfunc = new IronMiningFunction();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		String zone=loginInfo.getZone();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("AddorModifyMotherRouteMaster")) {
				try {

					String buttonValue = request.getParameter("buttonValue");
					String custId = request.getParameter("custId");
					String mRouteName = request.getParameter("mRouteName");
					String tsLimit = request.getParameter("tsLimit");
					String id = request.getParameter("id");
					
					String message="";
					//for(Object o:request.getParameterMap().keySet()) System.out.println((String)o+"::"+request.getParameter((String)o));
					if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
					{
	                     message=ironfunc.addMotherRouteDetails(systemId, Integer.parseInt(custId), userId, mRouteName, Integer.parseInt(tsLimit));
					}else if(buttonValue.equals("Modify") && custId != null && !custId.equals(""))
					{
						message=ironfunc.modifyMotherRouteDetails(systemId, Integer.parseInt(custId), userId, mRouteName, Integer.parseInt(tsLimit), Integer.parseInt(id));
					}
					
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		else if (param.equalsIgnoreCase("getMotherRouteMaster")) {
		        try {
		        	ArrayList list=null;
		            String custId = request.getParameter("custId");
		            String jspName=request.getParameter("jspName");
					String custName=request.getParameter("custName");
		            jsonArray = new JSONArray();
		            jsonObject = new JSONObject();
		            
		            if (custId != null && !custId.equals("")) {
		            	
		                list =ironfunc.getMotherRouteMaster(systemId, Integer.parseInt(custId));
		                jsonArray = (JSONArray) list.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("motherRouteMasterRoot", jsonArray);
		                } else {
		                    jsonObject.put("motherRouteMasterRoot", "");
		                }
		            ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("reportName","Mother Route Master");
	                request.getSession().setAttribute("custName", custName);
	                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
	    	}
		else if (param.equalsIgnoreCase("changeStatusForMotherRoute")) {
			try {
				String currStatus = request.getParameter("status");
				String inactiveReason = request.getParameter("inactiveReason");
				String motherRouteId = request.getParameter("motherRouteId");
				String message="";
				//for(Object o:request.getParameterMap().keySet()) System.out.println((String)o+"::"+request.getParameter((String)o));
                message=ironfunc.changeSubRoutesStatusForMotherRoute(inactiveReason ,currStatus, userId, Integer.parseInt(motherRouteId));
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getUsedTripsheetCount")) {
			String motherRouteId = request.getParameter("motherRouteId");
			if (motherRouteId != null && !motherRouteId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					String ip = request.getRemoteAddr();
					jsonarray = ironfunc.getUsedTripsheetCount(Integer.parseInt(motherRouteId));
					if (jsonarray.length() > 0) {
						jsonObject.put("usedTripsheetStoreRoot",jsonarray);
					} else {
						jsonObject.put("usedTripsheetStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}	

		return null;
	}


}


