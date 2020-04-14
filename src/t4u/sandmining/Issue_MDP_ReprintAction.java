package t4u.sandmining;

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
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.SandMiningPermitFunctions;

public class Issue_MDP_ReprintAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		String message="";
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		AdminFunctions adfunc = new AdminFunctions();
		SandMiningPermitFunctions smpf = new SandMiningPermitFunctions();
		systemId = loginInfo.getSystemId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		String ltspName = loginInfo.getSystemName();
		String userName = loginInfo.getUserName();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		} 
		if (param.equals("getFromSandPortStore")) {
			 try{
					String clientId=request.getParameter("clientId");
					jsonObject =new JSONObject();
					jsonArray = smpf.getFromSandPort(systemId,clientId,userId);
					jsonObject.put("FromSandPortStoreList", jsonArray);
					response.getWriter().print(jsonObject.toString());	
				}
				catch(Exception e){
					e.printStackTrace();
				}
		}else if(param.equals("getIssueReprintNewGRID")){
			try{
				String clientId=request.getParameter("clientId");
				jsonObject =new JSONObject();
				jsonArray = smpf.getIssueNosForReprint(systemId,clientId);
				jsonObject.put("TPOwnerstoreNewList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		
		else if (param.equals("getViewDetailsGRID")) {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			try {
				String clientId = request.getParameter("ClientId");
				String tpOwner = request.getParameter("tpOwner");
				String startDate = request.getParameter("startDate").replace('T', ' ');
				String endDate = request.getParameter("startDate").replace('T', ' ');
				endDate = endDate.substring(0,endDate.indexOf(" ")+1)+"23:59:59";
				if(clientId != null && !clientId.equals("")){
					ArrayList finlist = smpf.getViewSheetDetails(systemId, Integer.parseInt(clientId), offset, userId,tpOwner,startDate,endDate);
					jsonArray = (JSONArray) finlist.get(0);
					jsonObject.put("viewRoot", jsonArray);
					
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		
		return null;
	}
}