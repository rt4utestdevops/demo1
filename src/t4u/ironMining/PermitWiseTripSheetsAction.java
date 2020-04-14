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
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class PermitWiseTripSheetsAction extends Action{
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	
    	HttpSession session = request.getSession();
    	ReportHelper reportHelper = null;
        String param = "";
        int systemId = 0;
        int custmerid = 0;
        int userId = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        custmerid = loginInfo.getCustomerId();
        userId = loginInfo.getUserId();
		IronMiningFunction ironfunc = new IronMiningFunction();
        CommonFunctions cf = new CommonFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
    	
        if (param.equals("getPermits")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				int custId = 0;
				if (request.getParameter("custId") != null && !request.getParameter("custId").equals("")) {
					custId = Integer.parseInt(request.getParameter("custId"));
				}
				jsonArray = ironfunc.getPermitsForUser(systemId,custId,userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("permitStoreRoot", jsonArray);
				} else {
					jsonObject.put("permitStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in PermitWiseTripSheetsAction:-getPermitsForUser "+ e.toString());
			}
		}
        else if (param.equalsIgnoreCase("getTripSheetGenerationDetails")) {
			try {
				ArrayList list=null;
				String CustomerId = request.getParameter("CustID");
				String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
				String permitId=request.getParameter("permitId");
				String permitNo=request.getParameter("permitNo");
			//System.out.println("CustomerId:"+CustomerId+"jspName:"+jspName);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list =ironfunc.getTripSheetGenerationDetailsUsingPermit(systemId, Integer.parseInt(CustomerId),userId,Integer.parseInt(permitId));
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("miningTripSheetDetailsRoot", jsonArray);
					} else {
						jsonObject.put("miningTripSheetDetailsRoot", "");
					}
					reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName,reportHelper);
					request.getSession().setAttribute("jspTitle","Truck Trip Sheet Report");
					request.getSession().setAttribute("custName", customerName);
					request.getSession().setAttribute("permitNo", permitNo);
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("miningTripSheetDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
        else if (param.equalsIgnoreCase("getBargeTripSheetDetails")) {
			try {
				ArrayList list=null;
				String CustomerId = request.getParameter("CustID");
				String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
				String permitId=request.getParameter("permitId");
				String permitNo=request.getParameter("permitNo");
			//System.out.println("CustomerId:"+CustomerId+"jspName:"+jspName);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list =ironfunc.getTripSheetDetailsForBargeUsingPermit(systemId, Integer.parseInt(CustomerId),userId,Integer.parseInt(permitId));
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("miningTripSheetDetailsRoot", jsonArray);
					} else {
						jsonObject.put("miningTripSheetDetailsRoot", "");
					}
					reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName,reportHelper);
					request.getSession().setAttribute("jspTitle","Barge Trip Sheet Report");
					request.getSession().setAttribute("custName", customerName);
					request.getSession().setAttribute("permitNo", permitNo);
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("miningTripSheetDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
        else if (param.equalsIgnoreCase("getTruckTripSheetDetails")) {
			try {
				ArrayList list=null;
				String jspName=request.getParameter("jspName");
				String CustomerId = request.getParameter("CustID");
				String bargeId = request.getParameter("bargeId");
				String permitId = request.getParameter("permitId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list =ironfunc.getTruckTripSheetDetailsForPermit(systemId, Integer.parseInt(CustomerId),userId,Integer.parseInt(bargeId),Integer.parseInt(permitId));
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("miningTripSheetDetailsRoot", jsonArray);
					} else {
						jsonObject.put("miningTripSheetDetailsRoot", "");
					}
					reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName,reportHelper);
					//request.getSession().setAttribute("custId", customerName);
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("miningTripSheetDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
       }//if params   
	  return null;
    }
}
