package t4u.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;

import t4u.beans.LoginInfoBean;
import t4u.functions.AdminFunctions;

/**
 * 
 * This class is used to get,set  user feature group
 *
 */
public class UserFeatureDeatchmentAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response){
		HttpSession session = request.getSession();
		JSONArray jsonArray = new JSONArray();
		AdminFunctions adfuncs=new AdminFunctions();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		String language=loginInfo.getLanguage();
		int systemId=loginInfo.getSystemId();
		int createdUser=loginInfo.getUserId();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		
		String param = "";
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}
	
		/**
		 * To get feature group tree
		 */
		if(param.equals("getFeatureGroupTree")){
			try{
				
				String useridId="0";
				if(request.getParameter("userId")!=null){
					useridId=request.getParameter("userId").toString();
				}	
				
				String clientId="0";
				if(request.getParameter("clientId")!=null){
					clientId=request.getParameter("clientId").toString();
				}	
				
				 jsonArray=adfuncs.getFeatureGroupTree(language,useridId,clientId,systemId,createdUser);
				 
				response.getWriter().print(jsonArray);
				}catch(Exception e){
					System.out.println("Error in UserFeatureAction:-getFeatureGroupTree "+e.toString());
				}			
		}
		
		/**
		 * saving selected features checked by user
		 */
		
		else if(param.equals("savedeatchedfeatures")){
			try {
			
			String custId="0";
			if(request.getParameter("CustId")!=null){
				custId=request.getParameter("CustId");
			}
			
			String userId="0";
			if(request.getParameter("UserId")!=null){
				userId=request.getParameter("UserId");
			}
			
			String selectedfeatures="";
			if(request.getParameter("selectedFeatures")!=null){
				selectedfeatures=request.getParameter("selectedFeatures");
			}
			String pageName=request.getParameter("pageName");
		
			String message=adfuncs.saveUserFeatureDetaichmentInfo(systemId,custId,selectedfeatures,userId,createdUser,pageName,sessionId,serverName);
			response.getWriter().print(message);
			} catch (Exception e) {
				System.out.println("error in UserFeatureAction:--savedeatchedfeatures--"+e);
			}
			
		}
		
		return null;
	}

	
}