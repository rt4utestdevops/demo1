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
import t4u.functions.AdwiseManagementFunction;
import t4u.functions.CommonFunctions;

public class AdwiseManagementAction extends Action
{
		public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		AdwiseManagementFunction AdwiseManagement = new AdwiseManagementFunction();
		int systemId = 0;// loginInfo.getSystemId();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getUID")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = AdwiseManagement.getUID(systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("UIDRoot", jsonArray);
					jsonObject.put("IpUserPwd",jsonArray);
				} else {
					jsonObject.put("UIDRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		if (param.equals("getCameraDetails")) {
			try {
				String uid=request.getParameter("uidValue");
				int number = AdwiseManagement.getCameraDetails(uid);

				response.getWriter().print(number);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("setDetails")) {
			try {
				String Ip= request.getParameter("IP");
				String UserId = request.getParameter("UserId");
				String PwdID= request.getParameter("PwdID");
				String portID= request.getParameter("portID");
				String uid=request.getParameter("uidValue");
				String imei=request.getParameter("deviceId");
				String IntrID="";
				String CamFldID="";
				String camFtpId="";
				int count=0;
				if(request.getParameter("IntrID") != null && !request.getParameter("IntrID").equals("")){
					IntrID = request.getParameter("IntrID");	count++;
				}else{
					IntrID="badcommand";
				}
				if(request.getParameter("CamFldID") != null && !request.getParameter("CamFldID").equals("")){
					CamFldID = request.getParameter("CamFldID");	count++;
				}else{
					CamFldID="badcommand";
				}
				if(request.getParameter("camFtpId") != null && !request.getParameter("camFtpId").equals("") && !request.getParameter("camFtpId").equals("false")){
					camFtpId = request.getParameter("camFtpId");	count++;
				}else{
					camFtpId="badcommand";
				}
				String message = "";
				if(count==1){
					message=AdwiseManagement.setDetails(Ip,UserId,PwdID,IntrID,CamFldID,portID,camFtpId,uid,imei);
				}else{
					message="Please Select One Request";
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getDetails")) {
			try {
				String ftpGetId= "";
				String CamStatId = "";
				String camFldGetId= "";
				String uid=request.getParameter("uidValue");
				String imei=request.getParameter("deviceId");
				int count=0;
				if(request.getParameter("ftpGetId") != null && !request.getParameter("ftpGetId").equals("") && !request.getParameter("ftpGetId").equals("false")){
					ftpGetId = request.getParameter("ftpGetId");	count++;
				}
				else
				{
					ftpGetId="badcommand";
				}
				if(request.getParameter("CamStatId") != null && !request.getParameter("CamStatId").equals("") && !request.getParameter("CamStatId").equals("false")){
					CamStatId = request.getParameter("CamStatId");	count++;
				}
				else
				{
					CamStatId="badcommand";
				}
				if(request.getParameter("camFldGetId") != null && !request.getParameter("camFldGetId").equals("") && !request.getParameter("camFldGetId").equals("false")){
					camFldGetId = request.getParameter("camFldGetId");	count++;
				}
				else
				{
					camFldGetId="badcommand";
				}
				String message = "";
				if(count==1){
					message=AdwiseManagement.getDetails(ftpGetId,CamStatId,camFldGetId,uid,imei);
				}else{
					message="Please select one Request";
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}  
		else if(param.equals("getDetailsofCommands")){
			try {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			String imei=request.getParameter("imei");
			jsonArray = AdwiseManagement.getDetails(imei);
			if (jsonArray.length() > 0) {
				jsonObject.put("GridRoot", jsonArray);
			} else {
				jsonObject.put("GridRoot", "");
			}
			response.getWriter().print(jsonObject.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
			
			
		}
		return null; 
	}
}
