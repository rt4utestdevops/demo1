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
import t4u.common.DESEncryptionDecryption;
import t4u.functions.AdminFunctions;
/**
 * 
 * @author Ashutosh Kumar
 * @about This Action class Can perform adding, modifying and deleting action with user
 *
 */
public class UserManagementAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		HttpSession session=request.getSession();
		AdminFunctions adfunc=new AdminFunctions();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		int createdUser=loginInfo.getUserId();
		int customerId=loginInfo.getCustomerId();
		String serverName=request.getServerName();
		String sessionId1 = request.getSession().getId();
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		String param="";
		if(request.getParameter("param")!=null){
			param=request.getParameter("param").toString();
		}
		String contextPath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();		
/**
 * Saving user details and returning the response
 * 
 */
		
		if(param.equals("saveUserDetails")){
			try{
			
			String custName= request.getParameter("custName").trim();
			String userId=request.getParameter("userId").trim();
			String userName= request.getParameter("userName").trim();
			String newUserName="";
			if(request.getParameter("newUserName")!=null){
		     newUserName=request.getParameter("newUserName").trim();
			}
			//decrypting the password
			//String pass= request.getParameter("password").trim();
			//DESEncryptionDecryption DES = new DESEncryptionDecryption();
			String password = "";
			
		
			String firstName= request.getParameter("firstName").trim();
		
			String middleName="";
			if(request.getParameter("middleName")!=null){
				middleName=request.getParameter("middleName").trim();
								}
			
			String lastName="";
			if(request.getParameter("lastName")!=null){
				lastName=request.getParameter("lastName").trim();
								}
		
			String userPhone= "";
			if(request.getParameter("userPhone")!=null){
				userPhone=request.getParameter("userPhone").trim();
								}
			String userMobile= "";
			if(request.getParameter("userMobile")!=null){
				userMobile=request.getParameter("userMobile").trim();
								}
			
			String userEmail="";
			if(request.getParameter("userEmail")!=null){
				userEmail= request.getParameter("userEmail").trim();
								}
			String userFax="";
			if(request.getParameter("userFax")!=null){
				userFax=request.getParameter("userFax").trim();
			}
			String buttonValue=request.getParameter("buttonValue").trim();
			
			String branch="0";
			if(request.getParameter("branch")!=null && !request.getParameter("branch").equals("") ){
				branch=request.getParameter("branch");
			}
		
			String userAuth="0";
			if(request.getParameter("userAuth")!=null && !request.getParameter("userAuth").equals("")){
				userAuth=request.getParameter("userAuth");
			}
		
			String userStatus= request.getParameter("userStatus").trim();
			
			String roleId = "";
			if(request.getParameter("roleId")!=null){
				roleId=request.getParameter("roleId").trim();
			}
	
			boolean locset = false;
			if(request.getParameter("locationSetting")!=null && !request.getParameter("locationSetting").equals("") ){ 
					if ( request.getParameter("locationSetting").equalsIgnoreCase("true") || request.getParameter("locationSetting").equalsIgnoreCase("false")  ){
				locset = Boolean.parseBoolean(request.getParameter("locationSetting"));
			}
			}
			
			String emVisionId="";
			if(request.getParameter("emvision")!=null && !request.getParameter("emvision").equals("") ){
				emVisionId=request.getParameter("emvision");
			}
			String pageName=request.getParameter("pageName");
			String sessionId = adfunc.getRandomNumbers();
			boolean emailmodify = adfunc.isEmailModified(systemId,userEmail,userId);
			String message=adfunc.saveUserDetails(systemId, createdUser,buttonValue,userId, custName, userName,
					newUserName, password, firstName, middleName, lastName, userPhone, userEmail,userMobile,userFax,
					branch, userAuth, userStatus,emVisionId,sessionId,locset,pageName,sessionId1,serverName,roleId);
			if(message.contains("Saved Successfully") && ( buttonValue.equalsIgnoreCase("add") || emailmodify == true || userStatus.equalsIgnoreCase("Inactive") )){
				message = adfunc.sendmailToUser(userName,contextPath,sessionId,buttonValue);
				if(buttonValue.equalsIgnoreCase("add") || emailmodify == true){
				message = "Details Saved and Password Link Sent To User MailId.";
				}else{
					message = "User Details Updated Successfully.";	
				}

			}else{
				if(buttonValue.equalsIgnoreCase("add")){
					//message = "User Details Updated Successfully.";	
					message = "User Already available in Telematics Platform.";
				}else{
					message = "User Details Modified.";	
				}
			}
			response.getWriter().print(message);
			
		}catch(Exception e){
			System.out.println("Error in User Action:-saveUserDetails "+e.toString());
		}
		}
		
/**
 * getting userdetails from dbo.USERS
 */
		
		else if(param.equals("getUserDetails")){
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String custId=request.getParameter("CustId");
				jsonArray=adfunc.getUserDetails(systemId,custId);
				if(jsonArray.length()>0){
					jsonObject.put("UserDetailsRoot", jsonArray);
					
					}else{
						jsonObject.put("UserDetailsRoot", "");
					}
				
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in User Action:-getUserDetails "+e.toString());
			}
		}
		
		else if(param.equals("getUserProfileDetails")){
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(loginInfo.getIsLtsp()==0){
				customerId=0;
				}
				jsonArray=adfunc.getUserProfileDetails(systemId,createdUser,customerId);
				if(jsonArray.length()>0){
					jsonObject.put("UserDetailsRoot", jsonArray);
					
					}else{
						jsonObject.put("UserDetailsRoot", "");
					}
				
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in User Action:-getUserProfileDetails "+e.toString());
			}
		}
		

		
/**
 * deleting user details
 */
		else if(param.equals("deleteUserDetails")){
			try{
			String custName= request.getParameter("custId");
			
			String userId= request.getParameter("userId");
			String pageName=request.getParameter("pageName");
	
			
			String message=adfunc.deleteUserDetails(systemId, custName, userId,pageName,sessionId1,serverName,createdUser);
			response.getWriter().print(message);
			
		}catch(Exception e){
			System.out.println("Error in User Action:-deleteUserDetails "+e.toString());
		}
		}
		
		/**
		 * getBranches
		 */
		
		else if (param.equals("getBranches")) {
			String CustId="0";
			if(request.getParameter("CustId")!=null){
			 CustId=request.getParameter("CustId");
			}
			try {
				JSONArray list = new JSONArray();
				JSONObject rslt = new JSONObject();
				list = adfunc.getBranches(systemId, CustId);
				if(list.length()>0){
				rslt.put("branches", list);
				}else{
					rslt.put("branches", "");
				}
				response.getWriter().print(rslt.toString());
			} catch (Exception e) {
				System.out.println("Error in User Action:-getBranches "+e.toString());
			}

		}
		
		else if(param.equals("updateUserDetails")){
			try{
				
				if(loginInfo.getIsLtsp()==0)
				{
					customerId=0;
				}
				int mapType=0;
				//decrypting the password
				String pass= request.getParameter("password").trim();
				DESEncryptionDecryption DES = new DESEncryptionDecryption();
				String password = DES.encrypt(pass);
				
			
				String firstName= request.getParameter("firstName").trim();
			
				String middleName="";
				if(request.getParameter("middleName")!=null){
					middleName=request.getParameter("middleName").trim();
									}
				
				String lastName="";
				if(request.getParameter("lastName")!=null){
					lastName=request.getParameter("lastName").trim();
									}
			
				String userPhone= "";
				if(request.getParameter("userPhone")!=null){
					userPhone=request.getParameter("userPhone").trim();
									}
				String userMobile= "";
				if(request.getParameter("userMobile")!=null){
					userMobile=request.getParameter("userMobile").trim();
									}
				
				String userEmail="";
				if(request.getParameter("userEmail")!=null){
					userEmail= request.getParameter("userEmail").trim();
									}
				String userFax="";
				if(request.getParameter("userFax")!=null){
					userFax=request.getParameter("userFax").trim();
				}
				
				if(request.getParameter("mapType")!=null && !request.getParameter("mapType").equals("")){
					mapType=Integer.parseInt(request.getParameter("mapType"));
				}
				
				String message=adfunc.updateUserDetails(systemId,customerId, createdUser, password, firstName, middleName, lastName, userPhone, userEmail,userMobile,userFax,mapType);
				
				if(message!=null && !message.equals("") && !message.equals("error")){
					loginInfo.setMapType(mapType);
					session.setAttribute("loginInfoDetails", loginInfo);
				}
				response.getWriter().print(message);
				
			}catch(Exception e){
				System.out.println("Error in User Action:-saveUserDetails "+e.toString());
			}
				}
		
		else if (param.equals("getEmVision")) {
			String CustId="0";
			if(request.getParameter("CustId")!=null){
			 CustId=request.getParameter("CustId");
			}
			try {
				JSONArray list = new JSONArray();
				JSONObject rslt = new JSONObject();
				list = adfunc.getEmVisionList();
				if(list.length()>0){
				rslt.put("emVision", list);
				}else{
					rslt.put("emVision", "");
				}
				response.getWriter().print(rslt.toString());
			} catch (Exception e) {
				System.out.println("Error in User Action:-getEmVision "+e.toString());
			}

		}
		
		else if(param.equals("getPasswords"))
        {
			try
			{
			
			    int systemid= 0;;
				int customerid =0;
				int userid = 0;
			
				String systemIds = request.getParameter("SystemId");
				String customerIds = request.getParameter("CustomerId");
				String userId = request.getParameter("UserId");

                if(systemIds != null && !systemIds.equals(""))
				{
                	systemid = Integer.parseInt(systemIds);
				}				
				
				if(customerIds != null && !customerIds.equals(""))
				{
					customerid = Integer.parseInt(customerIds);
				}
				
				if(userId != null && !userId.equals(""))
				{
					userid = Integer.parseInt(userId);
				}
				
				jsonObject = new JSONObject();
				
					jsonArray = adfunc.getPasswordList(systemid, customerid,userid);	
					//System.out.println(" jsonArray == "+jsonArray);
					jsonObject.put("passwordStoreRoot", jsonArray);
					response.getWriter().print(jsonObject.toString());
					
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
	
	

		
		return null;
	}
}

	