package t4u.admin;



import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONObject;

import t4u.common.DESEncryptionDecryption;


public class PasswordRecoveryByEmailAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String param = "";
	
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if(param.equals("getEncPassword")){
			try{
			String descryptString = request.getParameter("Password");	
			System.out.println("descryptString ==== "+descryptString);
			DESEncryptionDecryption des=new DESEncryptionDecryption();
			String encryptedPassword = "";
			encryptedPassword  = des.encrypt(descryptString);
			System.out.println("encryptedPassword == "+encryptedPassword);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("cancelInfo", encryptedPassword);
			response.getWriter().print(jsonObject);			
			}catch(Exception e){
				e.printStackTrace();
			}
			}
			return null;
			}
}
