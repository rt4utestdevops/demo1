package t4u.admin;


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
import t4u.functions.AdminFunctions;

/**
 * 
 * This Class is used to save and set the AssetRegistration Details
 *
 */

public class AssetRegistrationAction extends Action {

	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		AdminFunctions adfunc= new AdminFunctions();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		int createdUser=loginInfo.getUserId();
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		String param = "";
		
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}
		
		/**
		 * Saving  Asset Registration Details in DB
		 */
		
		if(param.equals("saveAssetRegistrationDetails")){
			try {
				String assetType=request.getParameter("assetType");
				String custName=request.getParameter("custName");
				String regNo=request.getParameter("regNo");
				
				String message="save";
				response.getWriter().print(message);
			} catch (Exception e) {
				System.out.println("error in AssetRegistrationAction :-saveAssetRegistrationDetails"+e);
			}
		}
		
		
		/**
		 * setting the registration details in association page
		 */
		
		if(param.equals("setAssociationDetails")){
			try {
				String assetType=request.getParameter("assetType");
				String custName=request.getParameter("custName");
				String regNo=request.getParameter("regNo");
								
				session.setAttribute("ASSET_TYPE", assetType);
				session.setAttribute("CUST_NAME", custName);
				session.setAttribute("REG_NO", regNo);
				session.setAttribute("idd", "newdata");
				
			} catch (Exception e) {
				System.out.println("error in AssetRegistrationAction :-setAssociationDetails"+e);
			}
		}
		
		
		
		
		return null;
	}
}
