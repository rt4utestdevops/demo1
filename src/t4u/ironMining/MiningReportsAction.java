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

public class MiningReportsAction extends Action {
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
				IronMiningFunction ironMiningFunction = new IronMiningFunction();
				JSONArray jsonArray = null;
				JSONObject jsonObject = null;
				if (request.getParameter("param") != null) {
					param = request.getParameter("param").toString();
				}
				if (param.equalsIgnoreCase("getEwalletDetails")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						customerId=Integer.parseInt(request.getParameter("CustId"));
						String custName=request.getParameter("custName");
						String jspName=request.getParameter("jspName");
	                    ArrayList < Object > list=ironMiningFunction.getEwalletDetails(systemId,customerId);
	                    jsonArray = (JSONArray) list.get(0);
	                    if (jsonArray.length() > 0) {
							jsonObject.put("ewalletDetailsRoot", jsonArray);
						} else {
							jsonObject.put("ewalletDetailsRoot", "");
						}
	                    ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("reportName","Ewallet Details");
						request.getSession().setAttribute("custName", custName);
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						System.out.println("Error in ewalletdetailsaction....");
						e.printStackTrace();
					}
				}
				else if (param.equalsIgnoreCase("getMPLBalancesDetails")) {
					String custId=request.getParameter("custId");
					String custName=request.getParameter("custName");
					String jspName=request.getParameter("jspName");
					if (custId != null && !custId.equals("")) {
						customerId=Integer.parseInt(custId);
					}
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
	                    ArrayList < Object > list=ironMiningFunction.getMPLBalances(systemId,customerId);
	                    jsonArray = (JSONArray) list.get(0);
	                    if (jsonArray.length() > 0) {
							jsonObject.put("MPLBalancesRoot", jsonArray);
						} else {
							jsonObject.put("MPLBalancesRoot", "");
						}
	                    ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custName", custName);
						request.getSession().setAttribute("reportName", "MPL Balance Details");
						//System.out.println(jsonObject.toString());
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						e.printStackTrace();
					}
				}
				else if (param.equalsIgnoreCase("getImportsExportsReportDetails")) {
					String custId=request.getParameter("custId");
					String custName=request.getParameter("custName");
					String jspName=request.getParameter("jspName");
					
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
	                    ArrayList < Object > list=ironMiningFunction.getImportsExportsReportDetails(systemId,Integer.parseInt(custId));
	                    System.out.println(systemId+","+customerId);
	                    jsonArray = (JSONArray) list.get(0);
	                    if (jsonArray.length() > 0) {
							jsonObject.put("ImportsExportsRoot", jsonArray);
						} else {
							jsonObject.put("ImportsExportsRoot", "");
						}
	                    ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custName", custName);
						request.getSession().setAttribute("reportName", "Imports & Exports Details");
						//System.out.println(jsonObject.toString());
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						e.printStackTrace();
					}
				}
				else if (param.equalsIgnoreCase("getWalletReconciliationReport")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						String jspName=request.getParameter("jspName");
						String orgName=request.getParameter("orgName");
						String orgId = request.getParameter("orgId") != null&& !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
	                    ArrayList < Object > list=ironMiningFunction.getWalletReconciliationReport(systemId,customerId,Integer.parseInt(orgId));
	                    jsonArray = (JSONArray) list.get(0);
	                    if (jsonArray.length() > 0) {
							jsonObject.put("routeTripDetailsRoot", jsonArray);
						} else {
							jsonObject.put("routeTripDetailsRoot", "");
						}
	                    ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("reportName","Wallet Reconciliation Report");
						request.getSession().setAttribute("orgName", orgName);
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						System.out.println("Error in getWalletReconciliationReport....");
						e.printStackTrace();
					}
				}
				else if (param.equalsIgnoreCase("getStockReconciliationReport")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						String jspName=request.getParameter("jspName");
						String mineralType = "";
						if(request.getParameter("mineralType").contains("E-Auction")){
							mineralType="Iron Ore(E-Auction)";
						}else{
							mineralType="Iron Ore";
						}
						String orgId = request.getParameter("orgId") != null&& !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
						String hubId = request.getParameter("hubId") != null&& !request.getParameter("hubId").equals("") ? request.getParameter("hubId") : "0";
	                    ArrayList < Object > list=ironMiningFunction.getStockReconciliationReport(systemId,customerId,Integer.parseInt(hubId),Integer.parseInt(orgId),mineralType);
	                    jsonArray = (JSONArray) list.get(0);
	                    if (jsonArray.length() > 0) {
							jsonObject.put("stockReconciliationRoot", jsonArray);
						} else {
							jsonObject.put("stockReconciliationRoot", "");
						}
	                    ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("reportName","Stock Reconciliation Report");
						//request.getSession().setAttribute("orgName", orgName);
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						System.out.println("Error in getStockReconciliationReport....");
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
