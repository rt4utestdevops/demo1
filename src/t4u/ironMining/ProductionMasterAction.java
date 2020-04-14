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

public class ProductionMasterAction  extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		IronMiningFunction ironMiningFunction = new IronMiningFunction();
		//System.out.println("Action::"+this+" ||Class ::"+ironMiningFunction);
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		String zone=loginInfo.getZone();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getProductionMasterDetails")) {
	        try {
	            String custId = request.getParameter("custId");
	            String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("custName");
				String startDate=request.getParameter("startDate").substring(0, 10);
				String endDate=request.getParameter("endDate").substring(0, 10);
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (custId != null && !custId.equals("")) {
	            	ArrayList < Object > list =ironMiningFunction.getProductMasterDetails(systemId, Integer.parseInt(custId), userId, startDate, endDate);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("ProductionMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("ProductionMasterRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custName", customerName);
	                request.getSession().setAttribute("reportName", "Daywise Production");
	                request.getSession().setAttribute("startDate", startDate);
	                request.getSession().setAttribute("endDate", endDate);
	                response.getWriter().print(jsonObject.toString());
	            	
	            } 
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}	
			else if  (param.equalsIgnoreCase("getOrgName")) {
		    	 String clientId=request.getParameter("clientId");
		    	 try {
		    		 
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();
							jsonArray = ironMiningFunction.getOrgNamesForProductionMaster(systemId, Integer.parseInt(clientId), userId);
							if (jsonArray.length() > 0) {
								jsonObject.put("OrgnameRoot", jsonArray);
							}else {
								jsonObject.put("OrgnameRoot", "");
							}
							response.getWriter().print(jsonObject.toString());
						} catch (Exception e) {
		            e.printStackTrace();
		        }
		 }
			else  if (param.equals("getTCNumber")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String custId=request.getParameter("CustId");
					String orgId=request.getParameter("orgid");
					if (custId != null && !custId.equals("")) {
						jsonArray = ironMiningFunction.getTNoForProductionMaster(systemId,Integer.parseInt(custId),userId,Integer.parseInt(orgId));
						if (jsonArray.length() > 0) {
							jsonObject.put("tcNoRoot", jsonArray);
						} else {
							jsonObject.put("tcNoRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
//-------------------------------------Insert/Modify Plant Master Information-----------------------------------------------------------//
	     else if (param.equalsIgnoreCase("productionMasterAddModify")) {
		     try {
		        	String custId= request.getParameter("custId");
		        	String buttonValue = request.getParameter("buttonValue");
		        	String id = request.getParameter("id");
		        	String orgId = request.getParameter("orgId");
		        	String tcId = request.getParameter("tcId");
		        	String productionQty = request.getParameter("productionQty");
		        	String date = request.getParameter("date").substring(0,10);
		        	//for(Object o:request.getParameterMap().keySet()) System.out.println((String)o+"::"+request.getParameter((String)o));
		        	String message ="";
		            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
		              message = ironMiningFunction.saveProductionMaster(Integer.parseInt(orgId), Integer.parseInt(tcId), Double.parseDouble(productionQty), date, systemId, Integer.parseInt(custId), userId);
		            } 
		            else if (buttonValue.equals("Modify")&& custId != null && !custId.equals("")&& id != null && !id.equals("")) {
		              message = ironMiningFunction.upateProductionMaster(Integer.parseInt(orgId), Integer.parseInt(tcId), Double.parseDouble(productionQty), userId, Integer.parseInt(id));
		            }
		            response.getWriter().print(message);
	         } catch (Exception e) {
	        	 System.out.println("Error in Production Master Details "+e.toString());
	            e.printStackTrace();
	         }
		  }
	     else if (param.equalsIgnoreCase("getProductionSummaryDetails")) {
	        try {
	            String custId = request.getParameter("custId");
	            String jspName=request.getParameter("jspName");
				String custName=request.getParameter("custName");
				
				String startDate="";
				if(request.getParameter("startDate")!=null){
					startDate=request.getParameter("startDate").substring(0, 10);
				}
				String endDate="";
					if(request.getParameter("endDate")!=null){
						endDate=request.getParameter("endDate").substring(0, 10); 
				}
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (custId != null && !custId.equals("")) {
	            	ArrayList < Object > list =ironMiningFunction.getProductSummaryDetails(systemId, Integer.parseInt(custId), userId,startDate, endDate
);
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("ProductionSummaryRoot", jsonArray);
	                } else {
	                    jsonObject.put("ProductionSummaryRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("reportName", "Production Summary Details");
	                request.getSession().setAttribute("custName", custName);
	                response.getWriter().print(jsonObject.toString());
	            	
	            } 
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
		}
		
	return null;
	}
}
