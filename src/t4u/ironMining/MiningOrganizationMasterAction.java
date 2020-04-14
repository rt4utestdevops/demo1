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

public class MiningOrganizationMasterAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) {
	try {
		HttpSession session = request.getSession();
		String param = "";
		int systemId = 0;
		int customerId = 0;
		int userId = 0;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		if (loginInfo != null) {
			systemId = loginInfo.getSystemId();
			customerId = loginInfo.getCustomerId();
			userId = loginInfo.getUserId();
			IronMiningFunction ironMiningFunction = new IronMiningFunction();
			JSONArray jsonArray = null;
			JSONObject jsonObject = null;
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			if (param.equalsIgnoreCase("getMiningOrganizationMasterDetails")) {
				String CustId=request.getParameter("CustId");
				String custName=request.getParameter("custName");
				String jspName=request.getParameter("jspName");
				if (CustId != null && !CustId.equals("")) {
					customerId=Integer.parseInt(CustId);
				}
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try {
                    ArrayList < Object > list=ironMiningFunction.getMiningOrganizationMaster(systemId,customerId,userId);
                    jsonArray = (JSONArray) list.get(0);
                    if (jsonArray.length() > 0) {
						jsonObject.put("MiningOrganizationMasterRoot", jsonArray);
					} else {
						jsonObject.put("MiningOrganizationMasterRoot", "");
					}
                    ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custName", custName);
					request.getSession().setAttribute("reportName", "Mining Organization Master");
					response.getWriter().print(jsonObject.toString());
				}
				catch (Exception e) {
					System.out.println("Error in StockYardMasterAction....");
					e.printStackTrace();
				}
			}
//-------------------------------------Insert/Modify Mining Org Master Information-----------------------------------------------------------//
		     else if (param.equalsIgnoreCase("miningOrgMasterAddModify")) {
			     try {
			        	String CustId= request.getParameter("CustID");
			        	String buttonValue = request.getParameter("buttonValue");
			        	String id = request.getParameter("id");
			        	String orgCode = request.getParameter("orgCode");
			        	String orgName = request.getParameter("orgName");
			        	String aliasName = request.getParameter("aliasName");
			        	String gstNo=request.getParameter("gstNo");
			        	String message = "";
			        	
			            if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
			              message = ironMiningFunction.insertMiningOrganizationMasterInformation(systemId,Integer.parseInt(CustId),orgCode,orgName,aliasName,gstNo);
			            } 
			            else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")&& id != null && !id.equals("")) {
			              message = ironMiningFunction.updateMiningOrganizationMasterInformation(systemId,Integer.parseInt(CustId),orgCode,orgName,Integer.parseInt(id),aliasName,gstNo);
			            }
			            response.getWriter().print(message);
		         } catch (Exception e) {
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
