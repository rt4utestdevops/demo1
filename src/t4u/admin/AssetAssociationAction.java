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
 * This Class is used to save modify and delete  the AssetAssociation data Details
 *
 */

public class AssetAssociationAction extends Action {
 public ActionForward execute(ActionMapping mapping, ActionForm form,
		HttpServletRequest request, HttpServletResponse response)
		throws Exception {
	    HttpSession session = request.getSession();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		AdminFunctions adfunc= new AdminFunctions();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		int createdUser=loginInfo.getUserId();
		String param = "";
		
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}
		/**
		 * Saving  Asset Association Details in DB
		 */
		if(param.equals("saveAssetAssociationDetails")){
			try{
			String custName=request.getParameter("custName");
			String regNo=request.getParameter("regNo");
			String unitNo=request.getParameter("unitNo");
			String deviceimei=request.getParameter("deviceimei");
			String manufacturer=request.getParameter("manufacturer");
			String deviceReferenceId=request.getParameter("deviceReferenceId");
			String mobComNo=request.getParameter("mobileComboNo");
			String mobNo=request.getParameter("mobileNo");
			String  simNo=" ";
			if(request.getParameter("simNo")!=null)
			{
				simNo=request.getParameter("simNo");
			}
			
			String serviceProvider="";
			if(request.getParameter("serviceProvider")!=null)
			{
			serviceProvider=request.getParameter("serviceProvider");
			}
			String groupName=request.getParameter("groupName");
			
			String message="save";
			response.getWriter().print(message);	
			}catch(Exception e){
				System.out.println("Error in AssetAssociationAction:-saveAssetAssociationDetails");
			}
		}
		
		/**
		 * Modifying  Asset Association Details and saving in DB
		 */
		if(param.equals("modifyAssetAssociationDetails")){
			try{
			String custName=request.getParameter("custName");
			String regNo=request.getParameter("regNo");
			String unitNo=request.getParameter("unitNo");
			String deviceimei=request.getParameter("deviceimei");
			String manufacturer=request.getParameter("manufacturer");
			String deviceReferenceId=request.getParameter("deviceReferenceId");
			String mobComNo=request.getParameter("mobileComboNo");
			String mobNo=request.getParameter("mobileNo");
			String  simNo=" ";
			if(request.getParameter("simNo")!=null)
			{
				simNo=request.getParameter("simNo");
			}
			
			String serviceProvider="";
			if(request.getParameter("serviceProvider")!=null)
			{
			serviceProvider=request.getParameter("serviceProvider");
			}
			String groupName=request.getParameter("groupName");
			
			String message="save";
			response.getWriter().print(message);	
			}catch(Exception e){
				System.out.println("Error in AssetAssociationAction:-modifyAssetAssociationDetails");
			}
		}
		
		/**
		 * Deleting  Asset Association Details in DB
		 */
		if(param.equals("deleteAssetAssociationDetails")){
			try{
			String custName=request.getParameter("custName");
			String assetType=request.getParameter("assetType");
			String unitNo=request.getParameter("unitNo");
			String regCombo=request.getParameter("regCombo");
			String mobComNo=request.getParameter("mobileComboNo");
			String reasonForCan=request.getParameter("reasonForCan");
			
			
			String message="save";
			response.getWriter().print(message);	
			}catch(Exception e){
				System.out.println("Error in AssetAssociationAction:-deleteAssetAssociationDetails");
			}
		}
		
		
		
		
	return null;
}
}
