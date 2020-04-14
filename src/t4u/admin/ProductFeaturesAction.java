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
 * Customer or Group Product Features Action
 */
public class ProductFeaturesAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		
		HttpSession session=request.getSession();
		AdminFunctions adfunc=new AdminFunctions();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		int createUser=loginInfo.getUserId();
		String language=loginInfo.getLanguage();
		String categoryType=loginInfo.getCategoryType();
		String category=loginInfo.getCategory();
		String userName=loginInfo.getUserName();
		String systemName=loginInfo.getSystemName();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		String param = "";
		
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}
		/**
		 * get Product Mandatory Process
		 */
		if(param.equals("getProductMandatoryProcess")){
			try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if(request.getParameter("group").toString().equals("false")){
			jsonArray=adfunc.getProductMandatoryProcess(systemId,language,"0",false);		
			}else{
				jsonArray=adfunc.getProductMandatoryProcess(systemId,language,request.getParameter("custId").toString().trim(),true);	
			}
			if(jsonArray.length()>0){
				jsonObject.put("readerMandatorydata", jsonArray);
				}else{
					jsonObject.put("readerMandatorydata", "");
				}
			response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Exception in ProductFeaturesAction:-getProductMandatoryProcess"+e.toString());
			}
		}
		/**
		 * get Product Vertical Process 
		 */
		else if(param.equals("getProductVerticalProcess")){
			try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if(request.getParameter("group").toString().equals("false")){				
			jsonArray=adfunc.getProductVerticalProcess(systemId,language,"0",false);	
			}else{
				jsonArray=adfunc.getProductVerticalProcess(systemId,language,request.getParameter("custId").toString().trim(),true);	
			}if(jsonArray.length()>0){
				jsonObject.put("readerVerticaldata", jsonArray);
				}else{
					jsonObject.put("readerVerticaldata", "");
				}
			response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Exception in ProductFeaturesAction:-getProductVerticalProcess"+e.toString());
			}
		}
		/**
		 * get Product AddOn Process
		 */
		else if(param.equals("getProductAddOnProcess")){
			try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if(request.getParameter("group").toString().equals("false")){				
				jsonArray=adfunc.getProductAddOnProcess(systemId,language,"0",false);	
			}else{
				jsonArray=adfunc.getProductAddOnProcess(systemId,language,request.getParameter("custId").toString().trim(),true);	
			}if(jsonArray.length()>0){
				jsonObject.put("readerAddOndata", jsonArray);
				}else{
					jsonObject.put("readerAddOndata", "");
				}
			response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Exception in ProductFeaturesAction:-getProductAddOnProcess"+e.toString());
			}
		}
		/**
		 * get Product Process Details
		 */
		else if(param.equals("getProductProcessDetails")){
			try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if(request.getParameter("ProcessId")!=null){
				jsonArray=adfunc.getProductProcessDetails(systemId,language,request.getParameter("ProcessId").toString().trim());
			}
			if(jsonArray.length()>0){
				jsonObject.put("ProcessDetailsRoot", jsonArray);
				}else{
					jsonObject.put("ProcessDetailsRoot", "");
				}
			response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.toString();
				System.out.println("Exception in ProductFeaturesAction:-getProductProcessDetails"+e.toString());
			}
		}
		/**
		 * get Customer Group Process Details
		 */
		else if(param.equals("getCustomerGrpProcessDetails")){
			try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			if(request.getParameter("CustId")!=null && request.getParameter("GrpId")==null){
				jsonArray=adfunc.getCustomerGrpProcessDetails(systemId,request.getParameter("CustId").toString().trim(),"0");
			}else if(request.getParameter("CustId")!=null && request.getParameter("GrpId")!=null){
				jsonArray=adfunc.getCustomerGrpProcessDetails(systemId,request.getParameter("CustId").toString().trim(),request.getParameter("GrpId").toString().trim());
			}
			if(jsonArray.length()>0){
				jsonObject.put("CustomerGrpProcessDetailsRoot", jsonArray);
				}else{
					jsonObject.put("CustomerGrpProcessDetailsRoot", "");
				}
			response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.toString();
				System.out.println("Exception in ProductFeaturesAction:-getCustomerGrpProcessDetails"+e.toString());
			}
		}
		/**
		 * Saving or modifying Customer Mandatory Process Details returning the response
		 */
		else if(param.equals("saveCustomerMandatoryProcessDetails")){
			
			try{
				String ProcessTypeLabel=request.getParameter("ProcessTypeLabel");
				String custId= request.getParameter("custId");
				
				String grpId= request.getParameter("grpId");
				
				String showGrp= request.getParameter("showGrp");
				
				String checkedServices =request.getParameter("checkedServices");
				
				String uncheckedServices=request.getParameter("uncheckedServices");
				
				String custActivation=request.getParameter("custActivation");
				
				String grpActivation=request.getParameter("grpActivation");
				
				String custName=request.getParameter("custName");
				
				String pageName=request.getParameter("pageName");
				
				String message=adfunc.saveCustomerOrGroupMandatoryProcessAssociation(systemId, createUser, showGrp, custId, grpId, checkedServices,
						uncheckedServices,ProcessTypeLabel,custActivation,grpActivation,custName,categoryType,category,userName,systemName,pageName,sessionId,serverName);
				
				response.getWriter().print(message);	
			}catch(Exception e){
				System.out.println("Error in ProductFeaturesAction:-saveCustomerMandatoryProcessDetails "+e.toString());
			}			
		}
		
		/**
		 * Saving or modifying Customer Verticalized Process Details returning the response
		 */
		else if(param.equals("saveCustomerVerticalizedProcessDetails")){
			try{
				String ProcessTypeLabel=request.getParameter("ProcessTypeLabel");
				String custId= request.getParameter("custId");
				
				String grpId= request.getParameter("grpId");
				
				String showGrp= request.getParameter("showGrp");
				
				String checkedServices =request.getParameter("checkedServices");
				
				String uncheckedServices=request.getParameter("uncheckedServices");
				
				String custActivation=request.getParameter("custActivation");
				
				String grpActivation=request.getParameter("grpActivation");
				
				String custName=request.getParameter("custName");
				
				String pageName=request.getParameter("pageName");
				
				String message=adfunc.saveCustomerOrGroupVerticalizedProcessAssociation(systemId, createUser, showGrp, custId, grpId, checkedServices, uncheckedServices, 
						ProcessTypeLabel,custActivation,grpActivation,custName,categoryType,category,userName,systemName,pageName,sessionId,serverName);
				
				response.getWriter().print(message);	
			}catch(Exception e){
				System.out.println("Error in ProductFeaturesAction:-saveCustomerVerticalizedProcessDetails "+e.toString());
			}			
		}
		
		/**
		 * Saving or modifying Customer Addon Process Details returning the response
		 */
		else if(param.equals("saveCustomerAddsonProcessDetails")){
			try{
				String ProcessTypeLabel=request.getParameter("ProcessTypeLabel");
				String custId= request.getParameter("custId");
				
				String grpId= request.getParameter("grpId");
				
				String showGrp= request.getParameter("showGrp");
				
				String checkedServices =request.getParameter("checkedServices");
				
				String uncheckedServices=request.getParameter("uncheckedServices");
				
				String custActivation=request.getParameter("custActivation");
				
				String grpActivation=request.getParameter("grpActivation");
				
				String custName=request.getParameter("custName");
				
				String pageName=request.getParameter("pageName");
			
				String message=adfunc.saveCustomerOrGroupaddonProcessAssociation(systemId, createUser, showGrp, custId, grpId, checkedServices,
						uncheckedServices, ProcessTypeLabel,custActivation,grpActivation,custName,categoryType,category,userName,systemName,pageName,sessionId,serverName);
				
				response.getWriter().print(message);	
			}catch(Exception e){
				System.out.println("Error in ProductFeaturesAction:-saveCustomerAddsonProcessDetails "+e.toString());
			}			
		}
		return null;
	}
}
